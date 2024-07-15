//
//  DocumentView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/14/24.
//

import SwiftUI

struct DocumentView: View {
    @StateObject var vm: DocumentViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (vm.documents) { document in
                    if let description = document.description {
                        Text(description)
                    } else {
                        Text("No data")
                    }
                }
            }
            .task {
                do {
                    try await vm.fetchDocuments()
                } catch {
                    print("Error fetching documents in View; \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    DocumentView(vm: DocumentViewModel(member_id: 1))
}
