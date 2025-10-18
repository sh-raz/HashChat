//
//  ChatRoom.swift
//  HashChat
//
//  Created by shilani on 18/08/2024.
//

import Foundation
import FirebaseFirestore

struct ChatRoom: Codable, Identifiable {
    var id: String = UUID().uuidString
    var chatImage: String?
    var name: String = ""
    var recipient: User
    var lastMessage: String
    var lastMessageTime: Date
}
