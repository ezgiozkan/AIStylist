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
            supabaseURL: URL(string: "https://jkmgdprztpmtobrwiswe.supabase.co")!,
            supabaseKey: "sb_publishable_CAJNw3Y9UpCom8AgxV1ggw_wgyLrOzZ"
        )
    }
}
