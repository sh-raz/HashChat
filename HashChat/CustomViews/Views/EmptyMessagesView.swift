//
//  EmptyMessagesView.swift
//  HashChat
//
//  Created by shilani on 02/08/2024.
//

import UIKit

class EmptyMessagesView: UIView {
    
    let messageView = UIView()
    let messageLabel = TitleLabel(fontSize: 20, textAlignment: .left)
    let okButton = HCButton(title: "OK", theme: .orange)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        backgroundColor       = .systemBackground
        layer.cornerRadius    = 16
        layer.borderWidth     = 2
        layer.borderColor     = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
/*    func configureBackgroundView() {
        backgroundColor = .green
        alpha = 1
        configureMessageView()
        addSubview(messageView)
       
        messageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageView.widthAnchor.constraint(equalToConstant: self.frame.width * 3 / 4),
            messageView.heightAnchor.constraint(equalToConstant: self.frame.height * 1 / 2)
        ])
       
    }*/
    
    
/*    func configureMessageView(){
        messageView.addSubview(messageLabel)
        messageView.addSubview(okButton)
        
        messageView.backgroundColor = .brown
        messageView.alpha = 0.9
        messageView.layer.cornerRadius = 15
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 15),
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15),
            messageLabel.heightAnchor.constraint(equalToConstant: 100),
            
            okButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -15),
            okButton.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15),
            okButton.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -15),
            okButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        messageLabel.numberOfLines = 4
        messageLabel.text = "No messsages yet. start typing a message."
        
    }*/
    
   
    
    
    
}
