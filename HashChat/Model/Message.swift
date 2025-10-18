//
//  Message.swift
//  HashChat
//
//  Created by shilani on 12/07/2024.
//

import Foundation

struct Message:Codable {
    
    var id: String
    var text: String
    var sender: User? = nil
    var recipient: User? = nil
    var timestamp : Date
    var status: String
    
    init(id: String = UUID().uuidString, text: String, sender: User, recipient: User, timestamp: Date, status: String = "delivered") {
        self.id = id
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
        self.status = status
        self.recipient = recipient
    }
    
}
