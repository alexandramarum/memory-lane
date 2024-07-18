//
//  TimelineView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/15/24.
//

import SwiftUI

struct TimelineView: View {
    @ObservedObject var vm: MemberViewModel
    
    var body: some View {
        List(vm.familyDocuments) { document in
            Text(document.title)
        }
        .task {
            await vm.fetchFamilyDocuments()
        }
    }
}


#Preview {
    TimelineView(vm: MemberViewModel(family_id: 1))
}
