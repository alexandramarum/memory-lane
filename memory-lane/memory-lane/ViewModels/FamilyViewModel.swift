//
//  TestViewModel.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/13/24.
//

import Foundation

@MainActor
class FamilyViewModel: ObservableObject {
    @Published var families: [Family] = []
    @Published var email = ""
    @Published var password = ""
    
    func createFamily(text: String) async throws {
        let user = try await client.auth.session.user
        
        let family = Family(id: nil, created_at: Date(), family_name: text, user_id: user.id)
        
        try await client
            .from("Family")
            .insert(family)
            .execute()
        
        await fetchFamily()
    }
    
    func fetchFamily() async {
        do {
            let response: [Family] = try await client
                .from("Family")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            DispatchQueue.main.async {
                self.families = response
            }
        } catch {
            print("Error fetching families: \(error.localizedDescription)")
        }
    }
    
    func deleteFamily(at: Int) async throws {
        try await StorageManager.shared.deleteFamilyPhotos(familyId: at)
        
        let user = try await client.auth.session.user
        
        try await client
            .from("Family")
            .delete()
            .eq("id", value: at)
            .eq("user_id", value: user.id) // you can only delete a family if you created that family
            .execute()
        
        await fetchFamily()
    }
    
}
