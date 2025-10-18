//
//  ChatsCell.swift
//  HashChat
//
//  Created by shilani on 19/08/2024.
//

import UIKit

class ChatCell2: UITableViewCell {
    
    static let reuseID = "ChatCell2"
    var chatName = TitleLabel(fontSize: 25, textAlignment: .left)
    var lastMessage = DetailsLabel()
    var chatProfileImage = ProfileImageView(size: 70)
    var lastMessageTime = TimestampLabel()
    var lastMessageStatus = MessageStatusImageView(frame: .zero)
    var containerView = UIView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure() {
        contentView.addSubview(containerView)
        selectionStyle = .none
        setUpContainerView()
        configureProfileView()
        configureLabels()
    }
    
    
    private func configureLabels() {
        containerView.addSubview(chatName)
        containerView.addSubview(lastMessage)
        chatName.translatesAutoresizingMaskIntoConstraints = false
        
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatName.topAnchor.constraint(equalTo: chatProfileImage.topAnchor, constant: 2),
            chatName.leadingAnchor.constraint(equalTo: chatProfileImage.trailingAnchor, constant: 10),
           // chatName.bottomAnchor.constraint(equalTo: chatProfileImage.centerYAnchor, constant: -5),
            chatName.heightAnchor.constraint(equalToConstant: 45),
            chatName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            
            lastMessage.topAnchor.constraint(equalTo: chatName.bottomAnchor, constant: 0),
            lastMessage.leadingAnchor.constraint(equalTo: chatName.leadingAnchor, constant: 0),
            lastMessage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            lastMessage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
        ])
    }
    
    func configureStatusStackview() {
       
    }
    
    
    func configureProfileView() {
        containerView.addSubview(chatProfileImage)
        NSLayoutConstraint.activate([
            chatProfileImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chatProfileImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 10),
        ])
    }
    func setUpContainerView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 1),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 1),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -1),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -1),
        ])
    }

}

