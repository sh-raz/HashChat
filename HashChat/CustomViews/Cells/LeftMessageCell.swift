//
//  LeftMessageCell.swift
//  HashChat
//
//  Created by shilani on 02/11/2024.
//

import UIKit

class LeftMessageCell: UITableViewCell {
    
    static let reuseID  = "LeftMessageCell"
    
    //let stackView = UIStackView()
    let leftImageView = ProfileImageView(frame: .zero)
    var bubbleView = LeftBubbleView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setImage(image: UIImage){
        leftImageView.image = image
        leftImageView.layer.cornerRadius = leftImageView.frame.size.width / 2
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        leftImageView.layer.cornerRadius = leftImageView.frame.size.width / 2
        leftImageView.clipsToBounds = true
      }
    
    
    
    
    func configure() {
        contentView.addSubview(leftImageView)
        contentView.addSubview(bubbleView)
        NSLayoutConstraint.activate([
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftImageView.heightAnchor.constraint(equalToConstant: 40),
            leftImageView.widthAnchor.constraint(equalTo: leftImageView.heightAnchor, multiplier: 1),
            
            bubbleView.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 3),
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor,constant: -40),
        ])
        
        
        
        
        
        
//        contentView.addSubview(stackView)
//        configureStackView()
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
//        ])
    }
    
    
   
    
//    func configureStackView() {
//        stackView.axis = .horizontal
//        //stackView.alignment = .bottom
//        //stackView.distribution = .fillProportionally
//        stackView.contentMode = .scaleToFill
//        stackView.spacing = 3
//        stackView.addArrangedSubview(leftImageView)
//        stackView.addArrangedSubview(bubbleView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        selectionStyle = .none
//        NSLayoutConstraint.activate([
//            leftImageView.widthAnchor.constraint(equalToConstant: 40),
//            leftImageView.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
    
    func set(messageText text: String){
        bubbleView.set(text: text)
    }
}
