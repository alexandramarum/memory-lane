//
//  TestView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/13/24.
//

import SwiftUI

struct FamilyView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var vm: FamilyViewModel
    @State var isShowingSheet: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(vm.families) { family in
                        NavigationLink {
                            if let members = vm.familyMembers[family.family_name], let documents = vm.familyDocuments[family.family_name] {
                                HomeNavigationView(vm: MemberViewModel(family_id: family.id ?? 0, members: members, documents: documents, familyName: family.family_name))
                            }
                        } label: {
                            VStack(alignment: .leading){
                                Text(family.family_name)
                                    .bold()
                                    .font(.title3)
                                if vm.familyMembers[family.family_name]?.count == 1 {
                                    Text("\(vm.familyMembers[family.family_name]?.count ?? 0) Member")
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("\(vm.familyMembers[family.family_name]?.count ?? 0) Members")
                                        .foregroundStyle(.secondary)
                                }
                                if vm.familyDocuments[family.family_name]?.count == 1 {
                                    Text("\(vm.familyDocuments[family.family_name]?.count ?? 0) Document")
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("\(vm.familyDocuments[family.family_name]?.count ?? 0) Documents")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    try await vm.deleteFamily(at: family.id ?? 0)
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
                    Text("Add Family")
                        .bold()
                        .foregroundColor(.green)
                        .padding()
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .clipShape(.capsule)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Task {
                            do {
                                try await authManager.signOut()
                            } catch {
                                print("Error signing out: \(error)")
                            }
                        }
                    } label: {
                        Text("Sign Out")
                    }
                }
            }
            .navigationTitle("Family")
            .task {
                await vm.fetchFamily()
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            FamilySheetView(vm: vm, isShowingSheet: $isShowingSheet)
        }
    }
}

struct FamilySheetView: View {
    @ObservedObject var vm: FamilyViewModel
    @Binding var isShowingSheet: Bool
    @State var name: String = ""

    var body: some View {
        NavigationStack {
            Text("Family Name")
                .bold()
            TextField("", text: $name)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .padding()
                .navigationTitle("Create a Family")
            HStack {
                Button {
                    Task {
                        do {
                            try await vm.createFamily(text: name)
                        } catch {
                            print("Error creating family: \(error)")
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
        }
    }
}

#Preview {
    FamilyView(vm: FamilyViewModel())
}
