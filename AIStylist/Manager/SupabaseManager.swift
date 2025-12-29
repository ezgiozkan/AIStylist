//
//  SupabaseManager.swift
//  AIStylist
//
//  Created by Ezgi Özkan on 28.12.2025.
//


import Supabase
import Foundation

final class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://smvnnqwdhwseiqrmwxxc.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNtdm5ucXdkaHdzZWlxcm13eHhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1ODQ5MjQsImV4cCI6MjA3OTE2MDkyNH0._wEIZ4IJc04zTO4CORheQnBYTyLhyylmEoH0mW2wwY8"
        )
    }
}
