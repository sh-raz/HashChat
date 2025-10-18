//
//  ChatsViewController.swift
//  HashChat
//
//  Created by shilani on 27/07/2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatsViewController: UIViewController {
    
    let dbManager = DatabaseManager.shared
    let contactsManager = ContactsManager.shared
    var chatsTableView = UITableView()
    var headerView = UIView()
    var addButton = UIButton()
    var chats: [ChatRoom] = []
    var selectedUser: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newChatBarButtonPressed))
        addButton.tintColor = .purple
        navigationItem.title = "Chats"
        navigationItem.rightBarButtonItem = addButton
        configureMainView()
        configureTableView()
        Task{
            do{
               try await contactsManager.fetchContacts()
                DispatchQueue.main.async {
                    self.view.setNeedsLayout()
//                    self.fetchChatRooms()
                }
            }catch{
                print("Error fetching contacts: \(error)")
            }
        }
        fetchChatRooms()
    }

    init(){
        super.init(nibName: nil, bundle: nil)
    }
    init(selectedUser: User){
        super.init(nibName: nil, bundle: nil)
        self.selectedUser = selectedUser
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func configureMainView(){
        view.backgroundColor = .systemBackground
    }
   

    
    func fetchChatRooms() {
        dbManager.fetchChats {[weak self] chats in
            self?.chats = chats
            if let selectedUser = self?.selectedUser {
                let exixtingChat = chats.filter{ $0.name == selectedUser.name || $0.recipient == selectedUser}.first!
                let messageVC = MessagesViewController(chatRoom: exixtingChat)
                self?.navigationController?.pushViewController(messageVC, animated: false)
            }
            self?.chatsTableView.reloadData()
        }
    }
    
    
    @objc func newChatBarButtonPressed() {
        let contactsVC = ContactsViewController()
        contactsVC.modalPresentationStyle = .fullScreen
        tabBarController?.selectedIndex = 1
     }
    
}
//MARK: - Extensions

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell2" , for: indexPath) as! ChatCell2
        cell.selectionStyle = .none
        
        if chats.count > 0 || !contactsManager.contacts.isEmpty {
            cell.chatName.text = queryNameByEmail(email: chat.recipient.email)
            if let imageUrl = chat.chatImage {
                let intendedIndexPath = indexPath
                
                Task { [weak tableView, weak cell] in
                    let img = await dbManager.downloadImage(from: imageUrl)
                    await MainActor.run {
                        guard let tableView = tableView,
                              let cell = cell,
                              tableView.indexPath(for: cell) == intendedIndexPath else { return }
                        cell.chatProfileImage.image = img
                    }
                }
            }
            cell.lastMessage.text = chats[indexPath.row].lastMessage
            cell.lastMessageStatus.image = UIImage(named: "checkmark.circle.badge.questionmark")
        }
        return cell
    }

   
    
    func queryNameByEmail(email: String) -> String {
        for contact in contactsManager.contacts {
            if contact.emails.map({ $0.lowercased()}).contains(email.lowercased()) {
                return contact.fullName
            }
        }
        return ""
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
   
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHnadler in
            Task{
                await self.dbManager.deleteChat(withId: self.chats[indexPath.row].id )
                print(self.chats)
                completionHnadler(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoom = chats[indexPath.row]
        let chatMessagesVC = MessagesViewController(chatRoom: chatRoom)
        chatMessagesVC.modalPresentationStyle = .fullScreen
        let navigationController = UINavigationController(rootViewController: chatMessagesVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    
    func configureTableView() {
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        view.addSubview(chatsTableView)
        chatsTableView.frame = view.bounds
        chatsTableView.translatesAutoresizingMaskIntoConstraints = false
        chatsTableView.register(ChatCell2.self, forCellReuseIdentifier: "ChatCell2")
    }
}
