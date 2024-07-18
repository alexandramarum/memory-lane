//
//  ContentView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
  var body: some View {
      if authManager.isAuthenticated {
          FamilyView(vm: FamilyViewModel())
      }
      else {
          AuthView()
      }
  }
}

#Preview {
  ContentView()
        .environmentObject(AuthManager.shared)
}


