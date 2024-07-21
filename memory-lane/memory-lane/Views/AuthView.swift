//
//  AuthView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/13/24.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    @State var email: String = ""
    @State var password: String = ""
    @State var showAlert = false
    @State var alertTitle = Text("")
    @State var alertMessage = Text("")

  var body: some View {
      VStack {
          HStack{
              Text("Memory")
                  .font(.largeTitle)
                  .bold()
              Image(systemName: "tree")
                  .foregroundColor(.green)
                  .font(.largeTitle)
                  .bold()
                  .padding(-10)
              Text("Lane")
                  .font(.largeTitle)
                  .bold()
          }
          VStack {
              TextField("Email", text: $email)
                  .textFieldStyle(.roundedBorder)
                  .autocapitalization(.none)
              SecureField("Password", text: $password)
                  .textFieldStyle(.roundedBorder)
                  .autocapitalization(.none)
                  
          }
          .ignoresSafeArea(.keyboard)
          .padding(.leading)
          .padding(.trailing)
          .padding(.bottom)
          HStack {
              Button {
                  Task {
                      do {
                          try await authManager.signUp(email: email, password: password)
                          alertTitle = Text("Success!")
                          alertMessage = Text("You have successfully created an account. Sign in to get started.")
                          showAlert.toggle()
                      } catch {
                          alertTitle = Text("Error signing up")
                          alertMessage = Text("\(error.localizedDescription)")
                          showAlert.toggle()
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
              .alert(isPresented: $showAlert) {
                  Alert(title: alertTitle, message: alertMessage, dismissButton: .default(Text("Ok")))
              }
              Button {
                  Task{
                      do {
                          try await authManager.signIn(email: email, password: password)
                      } catch {
                          alertTitle = Text("Error signing in")
                          alertMessage = Text("\(error.localizedDescription)")
                          showAlert.toggle()
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
              .alert(isPresented: $showAlert) {
                  Alert(title: alertTitle, message: alertMessage, dismissButton: .default(Text("Ok")))
              }
              }
          }
      }
  }

#Preview {
  ContentView()
        .environmentObject(AuthManager.shared)
}


