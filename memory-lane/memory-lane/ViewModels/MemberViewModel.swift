//
//  MemberViewModel.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/14/24.
//

import Foundation

class MemberViewModel: ObservableObject {
    var family_id: Int
    @Published var members: [Member] = []
    @Published var familyDocuments: [Document] = []
    
    init(family_id: Int) {
        self.family_id = family_id
    }
    
    func createMember(first: String, last: String, birth: Date, death: Date?) async throws{
        let user = try await client.auth.session.user
        
        let member = Member(id: nil, created_at: Date(), first_name: first, last_name: last, date_of_birth: birth, date_of_death: death, family_id: family_id, user_id: user.id)
        
        try await client
            .from("Member")
            .insert(member)
            .execute()
        
        await fetchMembers()
    }
    
    func fetchMembers() async {
        do {
            let members: [Member] = try await client
                .from("Member")
                .select()
                .eq("family_id", value: family_id)
                .order("date_of_birth", ascending: true)
                .execute()
                .value
            
            DispatchQueue.main.sync {
                self.members = members
            }
        } catch {
            print("Error fetching members: \(error.localizedDescription)")
        }
    }
    
    func deleteMember(at: Int) async throws {
        try await client
            .from("Member")
            .delete()
            .eq("id", value: at)
            .execute()
        
        await fetchMembers()
    }
    
    func fetchFamilyDocuments() async {
        do {
            let documents: [Document] = try await client
                .from("Document")
                .select()
                .eq("family_id", value: family_id)
                .order("date", ascending: true)
                .execute()
                .value
            
            DispatchQueue.main.sync {
                self.familyDocuments = documents
            }
        } catch {
            print("Error fetching family documents: \(error)")
        }
    }
}
