//
//  ChatAppError.swift
//  HashChat
//
//  Created by Shilan on 14/03/2025.
//

import Foundation

enum ChatAppError: Error {
    case failedToFetchDataFromDatabase
    case failedAddingNewChatRoom
    case errorGettingDocumentsFromDatabase
    
    
    
    var description: String {
        switch self {
            
        case .failedToFetchDataFromDatabase:
            return "Failed to fetch data from Database"
        case .failedAddingNewChatRoom:
            return "Failed to a new chat room to the database"
        case .errorGettingDocumentsFromDatabase:
            return "Failed to fetch documents from database"
        }
    }
}
