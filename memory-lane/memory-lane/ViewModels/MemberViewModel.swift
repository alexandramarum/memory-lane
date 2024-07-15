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
    
    func fetchMembers() async {
        do {
            let members: [Member] = try await client
                .from("Member")
                .select()
                .eq("family_id", value: family_id)
                .execute()
                .value
            
            DispatchQueue.main.sync {
                self.members = members
            }
        } catch {
            print("Error fetching members: \(error.localizedDescription)")
        }
    }
    
    func fetchFamilyDocuments() async {
        do {
            let documents: [Document] = try await client
                .from("Document")
                .select()
                .eq("family_id", value: family_id)
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
