//
//  MembersView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/13/24.
//

import SwiftUI

struct HomeNavigationView: View {
    @ObservedObject var vm: MemberViewModel
    
    var body: some View {
        TabView {
            MemberListView(vm: vm)
                .tabItem {
                    Label("Members", systemImage: "person")
                }
            TimelineView(vm: vm)
                .tabItem {
                    Label("Timeline", systemImage: "tree")
                }
        }
        .accentColor(.green)
    }
}



#Preview {
    HomeNavigationView(vm: MemberViewModel(family_id: 1, members: [Member.example], documents: [Document.example], familyName: "Skywalker"))
}
