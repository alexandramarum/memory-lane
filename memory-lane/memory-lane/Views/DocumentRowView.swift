//
//  DocumentRowView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/17/24.
//

import SwiftUI

struct DocumentRowView: View {
    @ObservedObject var vm: DocumentViewModel
    var document: Document

    var body: some View {
        VStack {
            Text(document.title)
                .bold()
                .padding()
            if vm.images.isEmpty {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            } else {
                ScrollView(.horizontal){
                    HStack{
                        ForEach(vm.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .border(.green)
                        }
                    }
                }
            }
        }
        .task {
            do {
                try await vm.fetchPhoto(documentId: document.id)
            } catch { print("Error fetching photos: \(error)")
            }
        }
    }
}

#Preview {
    DocumentRowView(vm: DocumentViewModel(member_id: 1, family_id: 1), document: Document(id: UUID(), date: Date(), title: "Doc.ex", description: "example", member_id: 1, family_id: 1, user_id: UUID()))
}
