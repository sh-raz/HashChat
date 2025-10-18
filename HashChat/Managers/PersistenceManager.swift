//
//  PersistenceManager.swift
//  HashChat
//
//  Created by shilani on 09/10/2024.
//

import Foundation

struct PersistenceManager{
    static let shared = PersistenceManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    
    func saveDictonary(contacts: [Contact]) {
        let fileUrl = documentDirectory.appendingPathComponent("Contacts.text")
        do{
            let data = try JSONEncoder().encode(contacts) //JSONSerialization.data(withJSONObject: contacts)
            try data.write(to: fileUrl)
            
        }catch{
            print(error)
        }
    }
    
    
    
    
    func loadDictionary() -> [Contact] {
        let fileUrl = documentDirectory.appendingPathComponent("Contacts.text")
        do{
            let data = try Data(contentsOf: fileUrl)
            let contacts = try JSONDecoder().decode([Contact].self, from: data)
            return contacts
        }catch{
            print(error)
        }
        return []
    }
}
