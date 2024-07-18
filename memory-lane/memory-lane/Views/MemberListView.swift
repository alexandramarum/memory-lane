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
    
    var body: some View {
        VStack {
            List {
                ForEach(vm.members) { member in
                    NavigationLink {
                        if let memberID = member.id {
                            DocumentView(vm: DocumentViewModel(member_id: memberID, family_id: member.family_id))
                        }
                    } label: {
                        Text(member.first_name + " " + member.last_name)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                try await vm.deleteMember(at: member.id ?? 0)
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
                Text("Add Member")
                    .bold()
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .task {
           await vm.fetchMembers()
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
    @State var date_of_birth: Date = Date()
    @State var date_of_death: Date = Date()
    @State var isDeceased: Bool = false
    
    var body: some View {
        NavigationStack {
            Text("Required Information")
                .bold()
                .padding(.top)
            TextField("First Name", text: $first_name)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            TextField("Last Name", text: $last_name)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
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
    }
}

#Preview {
    MemberListView(vm: MemberViewModel(family_id: 1))
}
