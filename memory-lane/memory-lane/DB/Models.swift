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
    
    static var example: Family = Family(
        id: 1,
        created_at: Date(),
        family_name: "Skywalker",
        user_id: UUID())
}

struct Member: Decodable, Identifiable, Encodable, Hashable {
    let id: Int?
    let created_at: Date
    let first_name: String
    let last_name: String
    let date_of_birth: Date
    let date_of_death: Date?
    let family_id: Int
    let user_id: UUID
    
    static var example: Member = Member(
        id: 1,
        created_at: Date(),
        first_name: "LukeLONGNAMEYAYAYAYA",
        last_name: "Skywalker Really Long Last Name",
        date_of_birth: Date(),
        date_of_death: Date(),
        family_id: 1,
        user_id: UUID())
}

struct Document: Decodable, Identifiable, Encodable {
    let id: UUID
    let date: Date
    let title: String
    let description: String?
    let member_id: Int
    let family_id: Int
    let user_id: UUID
    
    static var example: Document = Document(
        id: UUID(),
        date: Date(),
        title: "Luke's Lightsaber",
        description: "Green kyber crystal",
        member_id: 1,
        family_id: 1,
        user_id: UUID())
}
