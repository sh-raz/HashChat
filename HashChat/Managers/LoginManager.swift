//
//  LoginManager.swift
//  HashChat
//
//  Created by shilani on 22/10/2024.
//

//import Foundation
//import Security
//
//struct LoginManager {
//    var username: String = ""
//    var password: String = ""
//    let server = "www.firebase.com"
//    
//    func saveToKeychain(username: String, password: String) throws {
//        let attributes: [String: Any] = [ kSecClass as String: kSecClassInternetPassword,
//                                          kSecAttrAccount as String: username,
//                                          kSecAttrServer as String: server,
//                                          kSecValueData as String: password.data(using: .utf8)! ]
//        let status = SecItemAdd(attributes as CFDictionary, nil)
//        print(status)
//        guard status == errSecSuccess else {
//            print("Something went wrong trying to save the user in the keychain")
//            throw KeychainError.unhandledError(status: status)
//        }
//        print("User saved successfully in the keychain")
//    }
    
    
    
//    func retrieveFromKeychain() throws -> (username: String, password: String) {
//        if let username = PersistenceManager.retrieveUsername() {
//            let query: [String: Any] = [
//                kSecClass as String: kSecClassInternetPassword,
//                kSecAttrAccount as String: username,
//                kSecMatchLimit as String: kSecMatchLimitOne,
//                kSecReturnAttributes as String: true,
//                kSecReturnData as String: true,
//            ]
//            
//            var item: CFTypeRef?
//            let status = SecItemCopyMatching(query as CFDictionary, &item)
//            guard status != errSecItemNotFound else { throw KeychainError.noPassword }
//            guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
//            
//            guard let existingItem = item as? [String : Any],
//                  let passwordData = existingItem[kSecValueData as String] as? Data,
//                  let password = String(data: passwordData, encoding: String.Encoding.utf8),
//                  let account = existingItem[kSecAttrAccount as String] as? String
//            else {
//                throw KeychainError.unexpectedPasswordData
//            }
//            return(account,password)
//        }
//        print("error PersistenceManager.retrieveUsername()")
//        throw KeychainError.noPassword
//    }
//}
