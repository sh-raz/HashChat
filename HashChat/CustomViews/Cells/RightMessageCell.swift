//
//  RightMessageCell.swift
//  HashChat
//
//  Created by shilani on 02/11/2024.
//

import UIKit

class RightMessageCell: UITableViewCell {
    static let reuseID  = "RightMessageCell"
    
    let stackView = UIStackView()
    let rightImageView = ProfileImageView(frame: .zero)
    var bubbleView = RightBubbleView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(messageText text: String){
        bubbleView.set(text: text)
    }
    
    func setImage(image: UIImage){
        rightImageView.image = image
        rightImageView.layer.cornerRadius = rightImageView.frame.size.width / 2
    }
    override func layoutSubviews() {
          super.layoutSubviews()
          rightImageView.layer.cornerRadius = rightImageView.frame.size.width / 2
          rightImageView.clipsToBounds = true
      }
    
    
    func configure() {
        contentView.addSubview(stackView)
        configureStackView()
        rightImageView.clipsToBounds  = true
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
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
    
    
}
