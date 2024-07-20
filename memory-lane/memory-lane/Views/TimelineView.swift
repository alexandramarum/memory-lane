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
        VStack {
            Text("\(vm.familyName) Timeline")
                .font(.largeTitle)
                .bold()
                .padding(-50)
            List {
                ForEach(vm.groupedByYear.keys.sorted(), id: \.self) { year in
                    Section(header: Text("\(year.description)")) {
                        ForEach(vm.groupedByYear[year] ?? []) { document in
                            NavigationLink(destination: DocumentRowView(vm: DocumentRowViewModel(owner: vm.getNameByDocumentId(id: document.id)),document: document)) {
                                HStack {
                                    Text(document.title)
                                        .bold()
                                    Spacer()
                                    Text(document.date, format: .dateTime.year().month().day())
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TimelineView(vm: MemberViewModel(family_id: 1, members: [Member.example], documents: [Document.example], familyName: "Skywalker"))
}
