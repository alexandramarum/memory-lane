//
//  DocumentView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/14/24.
//

import PhotosUI
import SwiftUI

struct DocumentView: View {
    @ObservedObject var vm: DocumentViewModel
    @State var isShowingSheet: Bool = false

    var body: some View {
        VStack {
            List {
                ForEach(vm.documents) { document in
                    DocumentRowView(document: document)
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    try await vm.deleteDocument(at: document.id)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            Button {
                isShowingSheet.toggle()
            } label: {
                Text("Add Document")
                    .bold()
                    .foregroundColor(.green)
                    .padding()
                    .background(.black)
                    .clipShape(.capsule)
            }
        }
        .task {
            await vm.fetchDocuments()
        }
        .sheet(isPresented: $isShowingSheet) {
            DocumentSheetView(vm: vm, isShowingSheet: $isShowingSheet)
        }
    }
}

struct DocumentSheetView: View {
    @ObservedObject var vm: DocumentViewModel
    @Binding var isShowingSheet: Bool
    @State var title: String = ""
    @State var description: String = ""
    @State var date: Date = .init()
    @State var giveDescription = false
    @State var photoPickerItems: [PhotosPickerItem] = []
    @State var photos: [UIImage] = []

    var body: some View {
        NavigationStack {
            PhotosPicker(selection: $photoPickerItems, maxSelectionCount: 5, selectionBehavior: .ordered) {
                if photos.count != 0 {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0 ..< photos.count, id: \.self) { i in
                                Image(uiImage: photos[i])
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "camera")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.green)
                        Text("Select photo(s)")
                    }
                }
            }
            .padding(.top)
            Text("Required Information")
                .bold()
                .padding()
            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            DatePicker("Date", selection: $date)
                .padding()
            Text("Optional")
                .bold()
            Toggle("Description", isOn: $giveDescription)
                .navigationTitle("Add Document")
                .padding(.leading)
                .padding(.trailing)
            if giveDescription {
                TextField("Description", text: $description)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
            }
            Spacer()
            HStack {
                Button {
                    Task {
                        do {
                            try await vm.createDocument(title: title, date: date, description: giveDescription ? description : nil, photos: photos)
                        } catch {
                            print("Error adding new document: \(error)")
                        }
                        isShowingSheet.toggle()
                    }
                } label: {
                    Text("Submit")
                        .bold()
                        .foregroundColor(.green)
                        .padding()
                        .background(.black)
                        .clipShape(.capsule)
                }
                Button {
                    isShowingSheet.toggle()
                } label: {
                    Text("Dismiss")
                        .bold()
                        .foregroundColor(.green)
                        .padding()
                        .background(.black)
                        .clipShape(.capsule)
                }
            }
            .padding()
        }
        .onChange(of: photoPickerItems) { _, _ in
            Task {
                for item in photoPickerItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            photos.append(image)
                        }
                    }
                }
                photoPickerItems.removeAll()
            }
        }
    }
}

#Preview {
    DocumentView(vm: DocumentViewModel(member_id: 1, family_id: 1))
}
