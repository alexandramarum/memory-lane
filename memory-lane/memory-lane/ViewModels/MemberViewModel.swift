//
//  MemberViewModel.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/14/24.
//

import Foundation

class MemberViewModel: ObservableObject {
    var family_id: Int
    @Published var members: [Member]
    @Published var documents: [Document]
    @Published var familyName: String
    
    init(family_id: Int, members: [Member], documents: [Document], familyName: String) {
        self.family_id = family_id
        self.members = members
        self.documents = documents
        self.familyName = familyName
    }
    
    var groupedByYear: [Int:[Document]] {
        Dictionary(grouping: documents) { document in
                   Calendar.current.component(.year, from: document.date)
               }
    }
    
    func createMember(first: String, last: String, birth: Date, death: Date?) async throws{
        let user = try await client.auth.session.user
        
        let member = Member(id: nil, created_at: Date(), first_name: first, last_name: last, date_of_birth: birth, date_of_death: death, family_id: family_id, user_id: user.id)
        
        try await client
            .from("Member")
            .insert(member)
            .execute()
        
        await fetchFamily()
    }
    
    func deleteMember(at: Int) async throws {
        try await StorageManager.shared.deleteMemberPhotos(memberId: at)
        
        try await client
            .from("Member")
            .delete()
            .eq("id", value: at)
            .execute()
        
        await fetchFamily()
    }
    
    func fetchFamily() async {
        do {
            let members: [Member] = try await client
                .from("Member")
                .select()
                .eq("family_id", value: family_id)
                .order("date_of_birth", ascending: true)
                .execute()
                .value
            
            let documents: [Document] = try await client
                .from("Document")
                .select()
                .eq("family_id", value: family_id)
                .order("date", ascending: true)
                .execute()
                .value
            
            DispatchQueue.main.sync {
                self.documents = documents
                self.members = members
            }
        } catch {
            print("Error fetching family: \(error)")
        }
    }
    
    func getAge(member: Member) -> String {
        return "\(Calendar.current.dateComponents([.year], from: member.date_of_birth, to: Date()).year!)"
    }
    
    func getNameByDocumentId(id: UUID) -> String {
        let documentDictionary: [UUID: Document] = Dictionary(uniqueKeysWithValues: self.documents.map { ($0.id, $0) })
        
        let memberDictionary: [Int: Member] = Dictionary(uniqueKeysWithValues: self.members.compactMap { member in
            guard let id = member.id else { return nil }
            return (id, member)
        })

        if let document = documentDictionary[id]{
            let memberId = document.member_id
            if let member = memberDictionary[memberId] {
                return member.first_name
            }
        }

        return ""
    }
}
