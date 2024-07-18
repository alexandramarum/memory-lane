//
//  TestViewModel.swift
//  memory-lane
//
//  Created by Alexandra Marum on 7/13/24.
//

import Foundation

enum AuthAction: String {
    case signUp = "Sign Up"
    case signIn = "Sign In"
}

enum AuthState {
    case authenticated
    case unauthenticated
}

@MainActor
class FamilyViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var authAction: AuthAction = .signUp // default action
    @Published var state: AuthState = .unauthenticated // default authorization
    
    @Published var families: [Family] = []
    
    @Published var email = ""
    @Published var password = ""
    
    func createFamily(text: String) async throws {
        let user = try await client.auth.session.user
        
        let family = Family(id: nil, created_at: Date(), family_name: text, user_id: user.id)
        
        try await client
            .from("Family")
            .insert(family)
            .execute()
        
        await fetchFamily()
    }
    
    func fetchFamily() async {
            do {
                let response: [Family] = try await client
                    .from("Family")
                    .select()
                    .order("created_at", ascending: false)
                    .execute()
                    .value
                
                DispatchQueue.main.async {
                    self.families = response
                }
            } catch {
                print("Error fetching families: \(error.localizedDescription)")
            }
        }
    
    func deleteFamily(at: Int) async throws {
        let user = try await client.auth.session.user
        
        try await client
            .from("Family")
            .delete()
            .eq("id", value: at)
            .eq("user_id", value: user.id) // you can only delete a family if you created that family
            .execute()
        
        await fetchFamily()
    }
    
    // Auth
    
    func signUp() async throws {
        _ = try await client.auth.signUp(email: email, password: password)
    }

    
    func signIn() async throws {
        _ = try await client.auth.signIn(email: email, password: password)
        state = .authenticated
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
    
    func authorize() async throws {
        switch authAction {
        case .signUp:
            try await signUp()
        case .signIn:
            try await signIn()
        }
    }

    // Test supabase connection by fetching from Family
    func testSupabaseConnection() {
        guard let url = URL(string: "https://jxjdzppcyjhholbxihjj.supabase.co/rest/v1/Family") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(Secrets.key, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("Response Data: \(jsonString)")
            }
        }
        
        task.resume()
    }
}
