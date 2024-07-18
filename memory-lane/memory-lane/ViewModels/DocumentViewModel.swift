//
//  DocumentViewModel.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/14/24.
//

import SwiftUI

class DocumentViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var images: [UIImage] = []
    
    private var member_id: Int
    private var family_id: Int
    private var storageManager = StorageManager()
    
    init(member_id: Int, family_id: Int) {
        self.member_id = member_id
        self.family_id = family_id
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
    
    func fetchPhoto(documentId: UUID) async throws {
        let folderPath = "document\(documentId)"
        
        // List all files in the specified folder
        let files = try await client.storage
            .from("Documents")
            .list(path: folderPath)

        // Load each image asynchronously
        var images: [UIImage] = []
        for file in files {
            if let image = try await storageManager
                .fetchImage(path: "\(folderPath)/\(file.name)") {
                images.append(image)
            }
        }

        DispatchQueue.main.async {
            self.images = images
        }
    }

}
