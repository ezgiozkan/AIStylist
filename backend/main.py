import os
import io
import json
import uuid
from fastapi import FastAPI, UploadFile, File, HTTPException, Query
from pydantic import BaseModel
from typing import List, Optional
from PIL import Image
from rembg import remove, new_session
from dotenv import load_dotenv

import google.generativeai as genai
from pinecone import Pinecone 
from supabase import create_client, Client

load_dotenv()

app = FastAPI(title="AI Stylist Backend", description="RAG-based Fashion Recommendation API")

# --- CONFIGURATION ---
rembg_session = new_session("u2netp")
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
ai_model = genai.GenerativeModel('gemini-2.5-flash')
supabase: Client = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_KEY"))
pc = Pinecone(api_key=os.getenv("PINECONE_API_KEY"))
index = pc.Index("clothing-index")

# --- DATA MODELS ---

class ClothingItemDetail(BaseModel):
    id: str
    category: str
    color: str
    image_url: str
    season: Optional[str] = None
    formality: Optional[str] = None
    description: Optional[str] = None

class ClothingResponse(BaseModel):
    id: str
    status: str
    image_url: str
    analysis: dict

class ClothingItemDetail(BaseModel):
    id: str
    category: str
    color: str
    image_url: str

class RecommendationRequest(BaseModel):
    weather: str
    occasion: str

class RecommendationResponse(BaseModel):
    outfit_name: str
    selected_items: List[ClothingItemDetail]
    reasoning: str

# New Models for Travel Feature
class TravelRequest(BaseModel):
    destination: str
    days: int
    weather: str

class TravelResponse(BaseModel):
    pack_name: str
    items_to_pack: List[ClothingItemDetail]
    outfit_combinations: List[str]
    reasoning: str

def get_embedding(text: str) -> List[float]:
    result = genai.embed_content(
        model="models/text-embedding-004",
        content=text,
        task_type="retrieval_document",
    )
    return result['embedding']

# --- ENDPOINTS ---

@app.post("/upload-clothing", response_model=ClothingResponse)
async def upload_clothing(file: UploadFile = File(...)):
    try:
        image_data = await file.read()
        input_image = Image.open(io.BytesIO(image_data))
        input_image.thumbnail((800, 800))
        output_image = remove(input_image, session=rembg_session)
        buffered = io.BytesIO()
        output_image.save(buffered, format="PNG")
        final_image_bytes = buffered.getvalue()

        file_name = f"{uuid.uuid4()}.png"
        supabase.storage.from_("wardrobe").upload(file_name, final_image_bytes, {"content-type": "image/png"})
        public_url_res = supabase.storage.from_("wardrobe").get_public_url(file_name)
        final_image_url = public_url_res if isinstance(public_url_res, str) else public_url_res.public_url

        prompt = "Analyze this clothing. Return JSON: {'category': '...', 'color': '...', 'season': '...', 'formality': '...', 'description': '...'}"
        response = ai_model.generate_content([prompt, output_image])
        metadata = json.loads(response.text.replace("```json", "").replace("```", "").strip())
        
        data_to_insert = {**metadata, "image_url": final_image_url}
        db_resp = supabase.table("clothes").insert(data_to_insert).execute()
        clothing_id = db_resp.data[0]['id']
        
        text_to_embed = f"{metadata['color']} {metadata['category']} {metadata['season']} {metadata['description']}"
        vector = get_embedding(text_to_embed)
        metadata['image_url'] = final_image_url
        index.upsert(vectors=[{"id": clothing_id, "values": vector, "metadata": metadata}])
        
        return {"id": clothing_id, "status": "Saved!", "image_url": final_image_url, "analysis": metadata}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/wardrobe", response_model=List[ClothingItemDetail])
async def get_wardrobe(category: Optional[str] = Query(None, description="Filter by category (e.g. 'Shoes')")):
    try:
        query = supabase.table("clothes").select("*").order("created_at", desc=True)
        
        if category:
            query = query.ilike("category", f"%{category}%") 
            
        response = query.execute()
        
        return response.data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/recommend-outfit", response_model=RecommendationResponse)
async def recommend_outfit(request: RecommendationRequest):
    try:
        search_query = f"{request.occasion} outfit for {request.weather} weather"
        query_vector = get_embedding(search_query)
        search_results = index.query(vector=query_vector, top_k=15, include_metadata=True)
        
        wardrobe_context = ""
        item_map = {}
        for match in search_results['matches']:
            meta = match['metadata']
            item_id = match['id']
            item_map[item_id] = {
                "id": item_id,
                "category": meta.get('category', 'Unknown'),
                "color": meta.get('color', 'Unknown'),
                "image_url": meta.get('image_url', '')
            }
            wardrobe_context += f"- ID: {item_id}, Item: {meta.get('color')} {meta.get('category')} ({meta.get('description')})\n"

        prompt = f"""
        Act as a stylist. Context: {request.occasion}, {request.weather}
        Wardrobe: {wardrobe_context}
        Task: Pick ONE Top and ONE Bottom (or Dress).
        Return JSON: {{ "outfit_name": "Name", "selected_items": ["ID_1", "ID_2"], "reasoning": "..." }}
        """
        response = ai_model.generate_content(prompt)
        recommendation = json.loads(response.text.replace("```json", "").replace("```", "").strip())
        
        full_items = []
        for item_id in recommendation['selected_items']:
            if item_id in item_map:
                full_items.append(item_map[item_id])
        
        return {
            "outfit_name": recommendation['outfit_name'],
            "selected_items": full_items,
            "reasoning": recommendation['reasoning']
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# --- NEW ENDPOINT: TRAVEL CAPSULE GENERATOR (Premium) ---
@app.post("/recommend-travel-pack", response_model=TravelResponse)
async def recommend_travel_pack(request: TravelRequest):
    try:
        # 1. Broad Search for the Destination
        search_query = f"Clothes suitable for {request.destination} in {request.weather}"
        query_vector = get_embedding(search_query)
        
        # Retrieve top 30 items to ensure variety
        search_results = index.query(vector=query_vector, top_k=30, include_metadata=True)
        
        item_map = {}
        wardrobe_context = ""
        for match in search_results['matches']:
            meta = match['metadata']
            item_id = match['id']
            item_map[item_id] = {
                "id": item_id,
                "category": meta.get('category'),
                "color": meta.get('color'),
                "image_url": meta.get('image_url')
            }
            wardrobe_context += f"- ID: {item_id}, {meta.get('color')} {meta.get('category')}\n"

        # 2. Generate Capsule Wardrobe
        prompt = f"""
        You are a Travel Stylist.
        Trip: {request.days} days to {request.destination}. Weather: {request.weather}.
        Available Items: {wardrobe_context}
        
        Task: Create a 'Capsule Wardrobe'.
        1. Select versatile items (Limit: {request.days + 2} items total).
        2. Create {request.days} different outfit combinations using ONLY these items (Mix & Match).
        
        Return JSON:
        {{
            "pack_name": "Creative Name",
            "items_to_pack": ["ID_1", ...],
            "outfit_combinations": ["Day 1: ID_1 + ID_3", ...],
            "reasoning": "..."
        }}
        """
        response = ai_model.generate_content(prompt)
        ai_result = json.loads(response.text.replace("```json", "").replace("```", "").strip())
        
        # Hydrate items
        packed_items_details = []
        for item_id in ai_result['items_to_pack']:
            if item_id in item_map:
                packed_items_details.append(item_map[item_id])

        return {
            "pack_name": ai_result['pack_name'],
            "items_to_pack": packed_items_details,
            "outfit_combinations": ai_result['outfit_combinations'],
            "reasoning": ai_result['reasoning']
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
