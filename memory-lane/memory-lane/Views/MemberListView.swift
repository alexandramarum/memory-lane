//
//  MemberListView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/15/24.
//

import SwiftUI

struct MemberListView: View {
    @ObservedObject var vm: MemberViewModel
    @State var isShowingSheet: Bool = false
    @State var memberToDelete: Member?

    var body: some View {
        VStack {
            Text("Family Members")
                .font(.title)
                .bold()
                .lineLimit(1)
                .truncationMode(.head)
                .padding(-50)
            List(vm.members) { member in
                NavigationLink {
                    if let memberID = member.id {
                        DocumentView(vm: DocumentViewModel(memberVm: vm, member_id: memberID, family_id: member.family_id, documents: vm.documents, name: member.first_name))
                    }
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(member.first_name + " " + member.last_name)
                                .font(.title3)
                            if member.date_of_death != nil {
                                Text("Deceased")
                                    .foregroundStyle(.secondary)
                                    .italic()
                            }
                        }

                        Text("Born \(member.date_of_birth.formatted().split(separator: ",")[0])")
                            .font(.subheadline)
                            .italic()
                        Text("Age \(vm.getAge(member: member))")
                            .foregroundStyle(.secondary)
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        memberToDelete = member
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .alert(item: $memberToDelete) { member in
                    Alert(
                        title: Text("Are you sure you want to delete this?"),
                        message: Text("Action cannot be undone"),
                        primaryButton: .destructive(Text("Delete")) {
                            Task {
                                try await vm.deleteMember(at: member.id ?? 0)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            Button {
                isShowingSheet.toggle()
            } label: {
                Text("Add Member")
                    .bold()
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.black)
                    .clipShape(.capsule)
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            MemberSheetView(vm: vm, isShowingSheet: $isShowingSheet)
        }
    }
}

struct MemberSheetView: View {
    @ObservedObject var vm: MemberViewModel
    @Binding var isShowingSheet: Bool
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var date_of_birth: Date = .init()
    @State var date_of_death: Date = .init()
    @State var isDeceased: Bool = false

    var body: some View {
        NavigationStack {
            Text("Required Information")
                .bold()
                .padding(.top)
            TextField("First Name", text: $first_name)
                .textFieldStyle(.roundedBorder)
            TextField("Last Name", text: $last_name)
                .textFieldStyle(.roundedBorder)
            DatePicker("Date of Birth", selection: $date_of_birth)
                .padding()
            Text("Optional")
                .bold()
                .padding(.top)
            Toggle("Deceased", isOn: $isDeceased)
                .navigationTitle("Add a Family Member")
                .padding(.leading)
                .padding(.trailing)
            if isDeceased {
                DatePicker("Date of Death", selection: $date_of_death)
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                    .padding(.trailing)
            }
            Spacer()
            HStack {
                Button {
                    Task {
                        do {
                            try await vm.createMember(first: first_name, last: last_name, birth: date_of_birth, death: isDeceased ? date_of_death : nil)
                        } catch {
                            print("Error adding new member: \(error)")
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
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MemberListView(vm: MemberViewModel(family_id: 1, members: [Member.example], documents: [Document.example], familyName: "Skywalker"))
}
