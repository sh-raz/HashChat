//
//  MainTabBarVC.swift
//  HashChat
//
//  Created by shilani on 25/01/2025.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .purple
        viewControllers = [createChatsVC(), createContactsVC(), createSettingVC()]
    }

    func createChatsVC() -> UINavigationController {
        let chatsVC = ChatsViewController()
        chatsVC.title = "Chats"
        chatsVC.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "bubble.left.and.bubble.right.fill"), tag: 0)
        let chatsNC = UINavigationController(rootViewController: chatsVC)
        chatsNC.navigationBar.prefersLargeTitles = true
        return chatsNC
    }

    func createContactsVC() -> UINavigationController {
        let contactsVC = ContactsViewController()
        contactsVC.title = "Contacts"
        contactsVC.tabBarItem = UITabBarItem(title: "Contacts", image: UIImage(systemName: "person.2.fill"), tag: 1)
        return UINavigationController(rootViewController: contactsVC)
    }

    func createSettingVC() -> UIViewController{
        let settingVC = SettingsVC()
        settingVC.title = "Setting"
        settingVC.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gear.circle.fill"), tag: 2)
        return settingVC
    }
}
