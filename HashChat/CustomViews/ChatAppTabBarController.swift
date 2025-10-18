//
//  ChatAppTabBarController.swift
//  HashChat
//
//  Created by shilani on 08/10/2024.
//

import UIKit

class ChatAppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGray
        viewControllers = [createChatsNC(), createContactsNC()]
    }
    
    
    func createChatsNC() -> UINavigationController {
        let chatsVC        = ChatsViewController()
        chatsVC.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 0) //UITabBarItem(tabBarSystemItem:
        
        return UINavigationController(rootViewController: chatsVC)
    }
    
    func createContactsNC() -> UINavigationController {
        let contactsVC        = ContactsViewController()
        contactsVC.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "person.2"), tag: 1) //UITabBarItem(tabBarSystemItem:
        
        return UINavigationController(rootViewController: contactsVC)
    }
    

}
