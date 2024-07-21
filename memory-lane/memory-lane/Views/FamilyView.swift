import SwiftUI

struct FamilyView: View {
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var vm: FamilyViewModel
    @State var isShowingSheet: Bool = false
    @State var familyToDelete: Family?

    var body: some View {
        NavigationStack {
            if vm.state == .working {
                VStack {
                    List {
                        ForEach(vm.families) { family in
                            NavigationLink {
                                HomeNavigationView(vm: MemberViewModel(family_id: family.id ?? 0, members: vm.familyMembers[family.family_name] ?? [], documents: vm.familyDocuments[family.family_name] ?? [], familyName: family.family_name))
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(family.family_name)
                                        .bold()
                                        .font(.title3)
                                    if let members = vm.familyMembers[family.family_name] {
                                        Text("\(members.count) Member\(members.count > 1 ? "s" : "")")
                                            .foregroundStyle(.secondary)
                                    }
                                    if let documents = vm.familyDocuments[family.family_name] {
                                        Text("\(documents.count) Document\(documents.count > 1 ? "s" : "")")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    familyToDelete = family
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
                            .background(Color.black)
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
                .alert(item: $familyToDelete) { family in
                    Alert(
                        title: Text("Are you sure you want to delete this?"),
                        message: Text("Action cannot be undone"),
                        primaryButton: .destructive(Text("Delete")) {
                            Task {
                                try await vm.deleteFamily(at: family.id ?? 0)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .sheet(isPresented: $isShowingSheet) {
                    FamilySheetView(vm: vm, isShowingSheet: $isShowingSheet)
                }
            } else {
                Image(systemName: "tree")
                    .foregroundColor(.green)
                    .font(.largeTitle)
                    .bold()
                    .padding(-10)
                Text("Loading...")
                    .bold()
                    .italic()
            }
        }
        .task {
            await vm.fetchFamily()
            vm.state = .working
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
