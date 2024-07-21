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
                .font(.title)
                .bold()
                .lineLimit(1)
                .truncationMode(.head)
                .padding(-50)
            List {
                ForEach(vm.groupedByYear.keys.sorted(), id: \.self) { year in
                    Section(header: Text("\(year.description)")) {
                        ForEach(vm.groupedByYear[year] ?? []) { document in
                            let name = vm.getNameByDocumentId(id: document.id)
                            NavigationLink(destination: DocumentRowView(vm: DocumentRowViewModel(owner: name),document: document)) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(document.title)
                                            .bold()
                                        Spacer()
                                        Text(document.date, format: .dateTime.year().month().day())
                                            .foregroundStyle(.secondary)
                                    }
                                    Text("Published by \(name)")
                                        .italic()
                                        .font(.subheadline)
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
