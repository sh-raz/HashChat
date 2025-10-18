//
//  ContactsViewController.swift
//  HashChat
//
//  Created by shilani on 22/07/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Contacts


class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dbManager = DatabaseManager.shared
    let contactsManager = ContactsManager.shared
    let contactsTable = UITableView()
    var registeredUsers: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
        Task {
            let contacts = try await contactsManager.fetchContacts()
            registeredUsers = await dbManager.fetchRegisteredUsers(from: contacts)
            self.contactsTable.reloadData()
        }
    }
    
    
    
    func configureTableView() {
        view.addSubview(contactsTable)
        contactsTable.delegate = self
        contactsTable.dataSource = self
        contactsTable.frame = view.bounds
        contactsTable.rowHeight = 80
        contactsTable.register(UserCell.self, forCellReuseIdentifier: "UserCell")
    }
    

    
  //MARK: -UITableView delegate and dataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return registeredUsers.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.userImageView.image = UIImage(systemName: "person.crop.circle")
        cell.detailStackView.set(nameLabel: registeredUsers[indexPath.row].name, detailLabel: "Last seen recently")
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task{
            let user = registeredUsers[indexPath.row]
            let chatRoom = await dbManager.quaryDatabase(for: user)
            if let chatRoom = chatRoom {
                let messagesVC = MessagesViewController(chatRoom: chatRoom)
                let navigationController = UINavigationController(rootViewController: messagesVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }else{
                let messagesVC = MessagesViewController(with: user)
                let navigationController = UINavigationController(rootViewController: messagesVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
  
        }
    }
}
