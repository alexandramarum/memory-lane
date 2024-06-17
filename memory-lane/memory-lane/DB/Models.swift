//
//  Models.swift
//  FamilyTree
//
//  Created by Alexandra Marum on 6/17/24.
//

import Foundation

struct Family: Decodable {
    let id: Int
    let name: String
    let user_id: UUID
}

struct Member: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let date_of_birth: Date
    let date_of_death: Date?
    let family_id: Int
}

struct Document: Decodable {
    let id: Int
    let date: Date
    let description: String
    let member_id: Int
}
