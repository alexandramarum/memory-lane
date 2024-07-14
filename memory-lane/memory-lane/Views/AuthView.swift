//
//  AuthView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/13/24.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var vm: FamilyViewModel

  var body: some View {
      VStack {
          HStack{
              Text("Memory")
                  .font(.largeTitle)
                  .bold()
              Image(systemName: "road.lanes.curved.left")
                  .foregroundColor(.green)
                  .font(.largeTitle)
                  .bold()
              Text("Lane")
                  .font(.largeTitle)
                  .bold()
          }
          VStack {
              TextField("Email", text: $vm.email)
                  .textFieldStyle(.roundedBorder)
                  .autocapitalization(.none)
              TextField("Password", text: $vm.password)
                  .textFieldStyle(.roundedBorder)
                  .autocapitalization(.none)
          }
          .padding(.leading)
          .padding(.trailing)
          .padding(.bottom)
          HStack {
              Button {
                  Task {
                      do {
                          try await vm.signUp()
                      } catch {
                          print("Error signing up: \(error.localizedDescription)")
                      }
                  }
              } label: {
                  Text("Sign Up")
                      .bold()
                      .foregroundColor(.green)
                      .padding()
                      .background(.black)
                      .clipShape(.capsule)
              }
              Button {
                  Task{
                      do {
                          try await vm.signIn()
                      } catch {
                          print("Error signing in: \(error.localizedDescription)")
                      }
                  }
              } label: {
                  Text("Sign In")
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
  ContentView()
}


