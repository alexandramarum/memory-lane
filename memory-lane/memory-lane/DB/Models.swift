//
//  Models.swift
//  FamilyTree
//
//  Created by Alexandra Marum on 6/17/24.
//

import Foundation

struct Family: Decodable, Identifiable, Encodable {
    let id: Int?
    let created_at: Date
    let family_name: String
    let user_id: UUID
}

struct Member: Decodable, Identifiable, Encodable, Hashable {
    let id: Int?
    let created_at: Date
    let first_name: String
    let last_name: String
    let date_of_birth: Date
    let date_of_death: Date?
    let family_id: Int
}

struct Document: Decodable, Identifiable, Encodable {
    let id: Int?
    let date: Date?
    let description: String?
    let member_id: Int
}
