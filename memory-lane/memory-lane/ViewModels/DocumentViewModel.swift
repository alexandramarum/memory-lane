//
//  DocumentViewModel.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/14/24.
//

import Foundation

class DocumentViewModel: ObservableObject {
    @Published var documents: [Document] = []
    var member_id: Int
    
    init(member_id: Int) {
        self.member_id = member_id
    }
    
    func fetchDocuments() async {
        do {
            let response: [Document] = try await client
                .from("Document")
                .select()
                .eq("member_id", value: member_id)
                .execute()
                .value
            
            DispatchQueue.main.async {
                self.documents = response
            }
            
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
}
