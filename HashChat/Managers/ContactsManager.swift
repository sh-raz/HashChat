//
//  ContactsManager.swift
//  HashChat
//
//  Created by Shilan on 17/03/2025.
//

import Foundation
import Contacts

class ContactsManager {
    static let shared = ContactsManager()
    init() {}
    
    let persistenceManager = PersistenceManager.shared
    var contacts: [Contact] = [] {
        didSet{
            persistenceManager.saveDictonary(contacts: contacts)
        }
    }
    
    func fetchContacts() async throws -> [Contact] {
        let task = Task.detached {
            let keys = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey as CNKeyDescriptor
            ]
            let request = CNContactFetchRequest(keysToFetch: keys)
            let store = CNContactStore()
            let formatter = CNContactFormatter()
            formatter.style = .fullName
            
            try store.enumerateContacts(with: request) { contact, stop in
                guard !Task.isCancelled else {
                    stop.pointee = true
                    return
                }
                
                let contact = Contact(
                    givenName: contact.givenName,
                    familyName: contact.familyName,
                    fullName: formatter.string(from: contact) ?? contact.givenName,
                    emails: contact.emailAddresses.map { $0.value as String }
                )
                if !self.contacts.contains(where: { $0.fullName == contact.fullName}) {
                    self.contacts.append(contact)
                }
            }
            try Task.checkCancellation()
            return self.contacts
        }
        return try await withTaskCancellationHandler {
            try await task.value
        } onCancel: {
            task.cancel()
        }
    }
    
    
    
    //    func addContactsForUser(contacts: [Contact]) {
    //        if let currentUser = Auth.auth().currentUser{
    //            Task{
    //                for contact in contacts {
    //                    do {
    //                        let ref = db.collection("users").document(currentUser.uid).collection("contacts").document()
    //                        try ref.setData(from: contact)
    //                        print("contact added with ID: \(ref.documentID)")
    //                    } catch {
    //                        print("Error adding contact: \(error)")
    //                    }
    //                }
    //
    //            }
    //
    //        }
    
}
