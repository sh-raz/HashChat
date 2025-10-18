//
//  User.swift
//  HashChat
//
//  Created by shilani on 23/07/2024.
//

import Foundation

struct User: Codable,Identifiable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    var name: String
    let email: String
    let imageUrl: String?
    let lastActive: Date?
    
    init(id: String ,name: String ,email: String) {
        self.id = id
        self.name = name
        self.email = email
        self.imageUrl = ""
        self.lastActive = nil
    }
}
