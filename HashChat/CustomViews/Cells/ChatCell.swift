//
//  ChatsCell.swift
//  HashChat
//
//  Created by shilani on 19/08/2024.
//

import UIKit

class ChatCell: UITableViewCell {
    
    static let reuseID = "ChatCell"
    var chatName = TitleLabel(fontSize: 25, textAlignment: .left)
    var lastMessage = DetailsLabel()
    var chatProfileImage = ProfileImageView(frame: .zero)
    var lastMessageTime = TimestampLabel()
    var lastMessageStatus = MessageStatusImageView(frame: .zero)
    
    var chatNameStackview = UIStackView()
    var statusStackview = UIStackView()
    var mainStackview = UIStackView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure() {
        contentView.addSubview(mainStackview)
        selectionStyle = .none
        
        configureChatNameStackview()
        configureStatusStackview()
        configureMainStackviw()
        
        NSLayoutConstraint.activate([
            mainStackview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            mainStackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mainStackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
    }
    
    
    private func configureChatNameStackview() {
        chatNameStackview.axis = .vertical
        chatNameStackview.alignment = .leading
        chatNameStackview.contentMode = .left
        chatNameStackview.distribution = .fillEqually
        chatNameStackview.addArrangedSubview(chatName)
        chatNameStackview.addArrangedSubview(lastMessage)
        chatNameStackview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureStatusStackview() {
        lastMessageTime.adjustsFontSizeToFitWidth = true
        lastMessageTime.minimumScaleFactor = 0.5
        
        statusStackview.axis = .horizontal
        statusStackview.contentMode = .center
        statusStackview.distribution = .fillEqually
        statusStackview.spacing = 3
        statusStackview.widthAnchor.constraint(equalToConstant: 100).isActive = true
        statusStackview.addArrangedSubview(lastMessageTime)
        statusStackview.addArrangedSubview(lastMessageStatus)
        
        statusStackview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configureMainStackviw() {
        mainStackview.axis = .horizontal
        mainStackview.contentMode = .center
        mainStackview.distribution = .fill
        mainStackview.spacing = 10
        chatProfileImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        mainStackview.addArrangedSubview(chatProfileImage)
        mainStackview.addArrangedSubview(chatNameStackview)
        mainStackview.addArrangedSubview(statusStackview)
        mainStackview.translatesAutoresizingMaskIntoConstraints = false
    }

}
