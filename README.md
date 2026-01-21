# AI Stylist

AI Stylist is a production-grade iOS application engineered to deliver intelligent wardrobe management and AI-driven outfit curation. The application leverages modern Swift concurrency patterns and a clean MVVM architecture to provide a seamless user experience.

## Core Capabilities

### Wardrobe Management System
- Comprehensive clothing item cataloging with persistent storage
- Hierarchical categorization engine supporting multi-level taxonomy (tops, bottoms, footwear, accessories)
- Metadata tagging for color, season, occasion, and fabric type

### AI-Powered Outfit Generation
- Computer vision integration for automated garment detection from user-uploaded imagery
- Context-aware outfit recommendation engine utilizing machine learning models
- Style preference learning through user interaction patterns

### Travel Capsule Optimization
- Algorithmic capsule wardrobe generation for travel scenarios
- Combinatorial outfit maximization with minimal item selection
- Weather and destination-aware packing recommendations

### Outfit Calendar Integration
- Calendar-based outfit planning with daily scheduling
- Historical outfit tracking and wear frequency analytics
- Visual timeline interface with weekly and monthly views

### Authentication and Security
- OAuth 2.0 implementation via Supabase Auth
- Google Sign-In integration with secure credential handling
- JWT-based session management with automatic token refresh

## Technical Architecture

| Layer | Technology |
|-------|------------|
| UI Framework | SwiftUI (iOS 15+) |
| Architecture Pattern | MVVM with Combine bindings |
| Backend Services | Supabase (PostgreSQL, Auth, Storage) |
| Concurrency Model | Swift async/await with structured concurrency |
| Networking | URLSession with custom REST client |
| Image Processing | Vision framework, Core Image |

## System Requirements

- Deployment Target: iOS 15.0+
- Development Environment: Xcode 15+
- Swift Version: 5.9+

## Project Structure

```
AIStyleist/
├── App/
│   └── AIStyleistApp.swift
├── Core/
│   ├── Network/
│   ├── Services/
│   └── Extensions/
├── Features/
│   ├── Wardrobe/
│   ├── OutfitBuilder/
│   ├── Calendar/
│   └── Authentication/
├── Models/
├── ViewModels/
└── Resources/
`
