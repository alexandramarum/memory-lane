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
    
    init(owner: String) {
        self.owner = owner
    }
    
    func fetchPhotos(documentId: UUID) async throws {
        let folderPath = "document\(documentId)"
        
        let files = try await client.storage
            .from("Documents")
            .list(path: folderPath)

        var images: [UIImage] = []
        for file in files {
            let filePath = "\(folderPath)/\(file.name)"
            if let image = StorageManager.shared.photos[filePath] {
                images.append(image)
            } else {
                if let fetchedImage = try await StorageManager.shared.fetchImage(path: filePath) {
                         images.append(fetchedImage)
                         StorageManager.shared.photos[filePath] = fetchedImage
                     }
                 }
            }
        DispatchQueue.main.async {
            self.images = images
        }
    }
}
