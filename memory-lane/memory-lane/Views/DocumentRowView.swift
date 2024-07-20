//
//  DocumentRowView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/17/24.
//

import SwiftUI

struct DocumentRowView: View {
    @ObservedObject var vm: DocumentRowViewModel
    var document: Document

    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(document.title)
                    .font(.title2)
                    .bold()
                    .padding(.leading)
                Spacer()
                Text(document.date, format: .dateTime.year().month().day())
                    .foregroundStyle(.secondary)
                    .padding(.trailing)
                    
            }
            Text("Published by \(vm.owner)")
                .padding(.leading)
                .padding(.bottom)
                .italic()
                .font(.title3)
                .foregroundStyle(.secondary)
            if let description = document.description {
                Text(description)
                    .font(.title3)
                    .padding(.leading)
                    .padding(.trailing)
            }
            if vm.images.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350)
                    }
                    .border(.green, width: 5)
                }
            } else {
                ScrollView(.horizontal){
                    HStack{
                        ForEach(vm.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350)
                        }
                    }
                    .border(.green, width: 5)
                }
            }
        }
        .padding(.top)
        Spacer()
        .task {
            do {
                try await vm.fetchPhotos(documentId: document.id)
            } catch { print("Error fetching photos: \(error)")
            }
        }
    }
}

#Preview {
    DocumentRowView(vm: DocumentRowViewModel(owner: "Luke"), document: Document(id: UUID(), date: Date(), title: "Image SF Symbol", description: "This is an example description. It can be as long as you'd like, really. In fact, it'd be beneficial to test the length of the description and see where changes can be made. Does it fill the space adequetely? I see one problem. It needs trailing padding. I really wish text justification existed, but alas.", member_id: 1, family_id: 1, user_id: UUID()))
}
