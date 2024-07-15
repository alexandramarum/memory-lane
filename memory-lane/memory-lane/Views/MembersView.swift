//
//  MembersView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/13/24.
//

import SwiftUI

struct MembersView: View {
    @StateObject var vm: MemberViewModel
    
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach(vm.members) { member in
                        NavigationLink {
                            if let memberID = member.id {
                                DocumentView(vm: DocumentViewModel(member_id: memberID))
                            }
                        } label: {
                            Text(member.first_name + " " + member.last_name)
                        }
                    }
                }
                .task {
                    do {
                        try await vm.fetchMembers()
                    } catch {
                        print("Error fetching members in MembersView: \(error.localizedDescription)")
                    }
                }
            }
            .tabItem {
                Label("Members", systemImage: "person")
            }
            
            
            NavigationStack {
                ForEach(vm.familyDocuments) { document in
                    if let description = document.description {
                        Text(description)
                    }
                }
                    }
                .task {
                    do {
                        try await vm.fetchFamilyDocuments()
                    } catch {
                        print("Error fetching members in MembersView: \(error.localizedDescription)")
                    }
                }
                .tabItem {
                    Label("Timeline", systemImage: "tree")
                }
            }
        }
    }

#Preview {
    MembersView(vm: MemberViewModel(family_id: 1))
}
