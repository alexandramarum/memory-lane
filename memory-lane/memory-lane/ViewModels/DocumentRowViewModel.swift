//
//  DocumentRowViewModel.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/18/24.
//

import SwiftUI

class DocumentRowViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    @Published var owner: String
    private var storageManager = StorageManager.shared
    
    init(owner: String) {
        self.owner = owner
    }
    
    func fetchPhotos(documentId: UUID) async throws {
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
