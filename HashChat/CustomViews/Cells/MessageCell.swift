//
//  MessageCell.swift
//  HashChat
//
//  Created by shilani on 02/09/2024.
//

import UIKit

enum MessageStyle {
    case left, right
}


class MessageCell: UITableViewCell {
    static let reuseID  = "MessageCell"
    
    let stackView = UIStackView()
    let leftImageView = ProfileImageView(frame: .zero)
    let rightImageView = ProfileImageView(frame: .zero)
    var bubbleView = RightBubbleView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        contentView.addSubview(stackView)
        configureStackView()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),    //equalTo: contentView.leadingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    
    func configureStackView() {

        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.addArrangedSubview(bubbleView)
        stackView.addArrangedSubview(rightImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        selectionStyle = .none
        NSLayoutConstraint.activate([
            rightImageView.widthAnchor.constraint(equalToConstant: 40),
            rightImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    
    
    func setMessageLayout(for messageStyle: MessageStyle, messageText: String) {
        switch messageStyle {
            
        case .left:
            //bubbleView = BubbleView(excludedCorner: .bottomLeft)
            rightImageView.isHidden = true
            leftImageView.isHidden = false
        case .right:
           // bubbleView = BubbleView(excludedCorner: .bottomRight)
            rightImageView.isHidden = false
            leftImageView.isHidden = true
        }
        configureBubbleView(messageText: messageText)
    }
   

    
    
    
    func configureBubbleView(messageText: String) {
        bubbleView.set(text: messageText)
        
        //let textPadding: CGFloat = 10
    }
  

}
