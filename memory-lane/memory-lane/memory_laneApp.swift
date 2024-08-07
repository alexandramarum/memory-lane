//
//  memory_laneApp.swift
//  memory-lane
//
//  Created by Alexandra Marum on 6/17/24.
//

import SwiftUI

@main
struct memory_laneApp: App {
    @StateObject var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}
