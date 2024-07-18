//
//  StorageManager.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/17/24.
//

import Supabase
import SwiftUI

class StorageManager {
    static let shared = StorageManager()
    
    func uploadPhoto(documentId: UUID, file: File) async throws {
        do {
            let folderPath = "document\(documentId)"
            try await client.storage
                .from("Documents")
                .upload(path: "\(folderPath)/\(file.name)", file: file.data)
        } catch {
            print(error)
        }
    }
    
    func uploadPhotos(documentId: UUID, photos: [UIImage]) async throws {
        for (i, photo) in photos.enumerated() {
            guard let imageData = photo.jpegData(compressionQuality: 0.8) else {
                throw NSError(domain: "ImageConversionError", code: 1)
            }
            
            let file = File(name: "photo\(i + 1).jpg", data: imageData, fileName: "photo\(i + 1).jpg", contentType: "jpg")
        
            try await uploadPhoto(documentId: documentId, file: file)
        }
    }
 

    func fetchImage(path: String) async throws -> UIImage? {
        let data = try await client.storage
            .from("Documents")
            .download(path: path)

        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageLoadingError", code: 2, userInfo: nil)
        }
        
        return image
    }

    
    func deletePhotos(documentId: UUID) async throws {
        
        do {
            let folderPath = "document\(documentId)"
            
            // List all files in the folder
            let files = try await client.storage
                .from("Documents")
                .list(path: folderPath)
            
            // Get the paths of all files
            let filePaths = files.map { "\(folderPath)/\($0.name)" }
            
            // Remove each file
            if !filePaths.isEmpty {
                try await client.storage
                    .from("Documents")
                    .remove(paths: filePaths)
            }
        } catch {
            print("Error deleting photos: \(error)")
        }
    }
    
    func deleteMemberPhotos(memberId: Int) async throws {
        do {
            let docs: [Document] = try await client
                .from("Document")
                .select()
                .eq("member_id", value: memberId)
                .execute()
                .value
            
            for doc in docs {
                try await StorageManager.shared.deletePhotos(documentId: doc.id)
            }
            
        } catch {
            print("Error deleting member documents: \(error)")
        }
    }
    
    func deleteFamilyPhotos(familyId: Int) async throws {
        do {
            let members: [Member] = try await client
                .from("Member")
                .select()
                .eq("family_id", value: familyId)
                .execute()
                .value
            
            for member in members {
                if let memberId = member.id {
                    try await StorageManager.shared.deleteMemberPhotos(memberId: memberId)
                }
            }

        } catch {
            print("Error deleting family documents: \(error)")
        }
    }
}
