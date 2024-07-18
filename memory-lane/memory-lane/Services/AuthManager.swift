//
//  AuthManager.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/18/24.
//

import Foundation
import Supabase

enum AuthAction: String {
    case signUp = "Sign Up"
    case signIn = "Sign In"
}

enum AuthState {
    case authenticated
    case unauthenticated
}

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var state: AuthState = .unauthenticated // default authorization
    
    init() { }
    
    func signUp(email: String, password: String) async throws {
        _ = try await client.auth.signUp(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        _ = try await client.auth.signIn(email: email, password: password)
        state = .authenticated
        isAuthenticated = true
    }
    
    func isUserAuthenticated() async {
        do {
            _ = try await client.auth.session.user
            isAuthenticated = true
            state = .authenticated
        } catch {
            isAuthenticated = false
            state = .unauthenticated
        }
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
        isAuthenticated = false
        state = .unauthenticated
    }
    
    func authorize(authAction: AuthAction, email: String, password: String) async throws {
        switch authAction {
        case .signUp:
            try await signUp(email: email, password: password)
        case .signIn:
            try await signIn(email: email, password: password)
        }
    }
}
