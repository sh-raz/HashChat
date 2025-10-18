//
//  ContactTaViCell.swift
//  HashChat
//
//  Created by shilani on 01/08/2024.
//

import UIKit

class UserCell: UITableViewCell {
    
    static let reuseID  = "UserCell"
    let userImageView = ProfileImageView(frame: .zero)
    let detailStackView = UserDetailsStackView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(userImageView)
        addSubview(detailStackView)
        
        accessoryType           = .none
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 60),
            userImageView.heightAnchor.constraint(equalToConstant: 60),
            
            detailStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            detailStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            detailStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            detailStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10)
        ])
    }
}
