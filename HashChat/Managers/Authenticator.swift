//
//  Authenticator.swift
//  HashChat
//
//  Created by shilani on 09/10/2024.
//

import Foundation
import FirebaseAuth

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}
@MainActor
class Authenticator {
    static var authenticationState: AuthenticationState = .unauthenticated
    var isUserLoggedIn: Bool { return Auth.auth().currentUser != nil }
    
    static func signIn(username: String, password: String) async -> Bool {
        authenticationState = .authenticating
        do{
            try await Auth.auth().signIn(withEmail: username, password: password)
            authenticationState = .authenticated
            return true
        }catch{
           print(error)
            authenticationState = .unauthenticated
            return false
        }
    }
   
    static func signUp(username: String, password: String) async -> Bool {
      authenticationState = .authenticating
      do  {
        try await Auth.auth().createUser(withEmail: username, password: password)
        return true
      }
      catch {
        print(error)
        authenticationState = .unauthenticated
        return false
      }
    }
    
    
    @discardableResult
      static func signOut() -> Bool {
          do {
              try Auth.auth().signOut()
              authenticationState = .unauthenticated
              return true
          } catch {
              print("signOut error:", error)
              authenticationState = .unauthenticated
              return false
          }
      }
    
    
    
}
