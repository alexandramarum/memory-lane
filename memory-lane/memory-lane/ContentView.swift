//
//  ContentView.swift
//  memory-lane
//
//  Created by Alexandra Marum on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: FamilyViewModel = FamilyViewModel()
    
  var body: some View {
      if vm.state == .authenticated {
          FamilyView(vm: vm)
      }
      else {
          AuthView(vm: vm)
      }
  }
}

#Preview {
  ContentView()
}


