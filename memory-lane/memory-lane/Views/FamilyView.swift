//
//  TestView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/13/24.
//

import SwiftUI

struct FamilyView: View {
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var vm: FamilyViewModel
    @State var isShowingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.families) { family in
                    NavigationLink {
                        HomeNavigationView(vm: MemberViewModel(family_id: family.id ?? 0))
                    } label : {
                        Text(family.family_name)
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
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
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
