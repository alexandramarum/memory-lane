//
//  DocumentViewModel.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/14/24.
//

import SwiftUI

class DocumentViewModel: ObservableObject {
    @Published var documents: [Document]
    @Published var images: [UIImage] = []
    @Published var name: String
    
    private var member_id: Int
    private var family_id: Int
    private var storageManager = StorageManager.shared
    
    init(member_id: Int, family_id: Int, documents: [Document], name: String) {
        self.member_id = member_id
        self.family_id = family_id
        self.documents = documents
        self.name = name
    }
    
    var filteredDocuments: [Document] {
          documents.filter { $0.member_id == member_id }
      }
    
    var groupedByYear: [Int:[Document]] {
        Dictionary(grouping: filteredDocuments) { document in
                   Calendar.current.component(.year, from: document.date)
               }
    }
    
    func createDocument(title: String, date: Date, description: String?, photos: [UIImage]) async throws {
        let user = try await client.auth.session.user
        let documentId = UUID()
        
        let document = Document(id: documentId, date: date, title: title, description: description, member_id: member_id, family_id: family_id, user_id: user.id)
        
        try await client
            .from("Document")
            .insert(document)
            .execute()
        
        try await storageManager.uploadPhotos(documentId: documentId, photos: photos)
        
        await fetchDocuments()
    }
    
    func fetchDocuments() async {
        do {
            let response: [Document] = try await client
                .from("Document")
                .select()
                .eq("member_id", value: member_id)
                .order("date", ascending: true)
                .execute()
                .value
            
            DispatchQueue.main.async {
                self.documents = response
            }
            
            
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
    
    func deleteDocument(at: UUID) async throws {
        try await client
            .from("Document")
            .delete()
            .eq("id", value: at)
            .execute()
        
        try await storageManager.deletePhotos(documentId: at)
        await fetchDocuments()
        
    }

}
