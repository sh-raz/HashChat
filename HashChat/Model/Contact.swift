//
//  Contact.swift
//  HashChat
//
//  Created by shilani on 22/07/2024.
//

import Foundation

struct Contact: Codable {
    var givenName: String
    var familyName: String
    var fullName: String
    var emails: [String]
}
