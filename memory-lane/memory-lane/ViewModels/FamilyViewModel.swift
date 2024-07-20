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
    @Published var familyMembers: [String: [Member]] = [:]
    @Published var familyDocuments: [String: [Document]] = [:]
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
            
            var tempFamilyMembers: [String:[Member]] = [:]
            var tempFamilyDocuments: [String:[Document]] = [:]
            
            for family in response {
                let members: [Member] = try await client
                    .from("Member")
                    .select()
                    .eq("family_id", value: family.id)
                    .execute()
                    .value
                
                tempFamilyMembers[family.family_name] = members
                
                for member in members {
                    let documents: [Document] = try await client
                        .from("Document")
                        .select()
                        .eq("family_id", value: family.id)
                        .execute()
                        .value
                    
                    tempFamilyDocuments[family.family_name] = documents
                    
                    DispatchQueue.main.async {
                        self.families = response
                        self.familyDocuments = tempFamilyDocuments
                        self.familyMembers = tempFamilyMembers
                        
                    }

                }
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
