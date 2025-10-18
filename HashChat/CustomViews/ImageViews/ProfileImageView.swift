//
//  UserImageView.swift
//  HashChat
//
//  Created by shilani on 31/07/2024.
//

import UIKit

class ProfileImageView: UIImageView {
    //let cache               = NetworkManager.shared.cache
    let placeholderImage    = UIImage(resource: .profile)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    convenience init(size: CGFloat) {
        self.init(frame: .zero)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size),
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        ])
        layer.cornerRadius = size / 2
    }
    
    private func configure() {
        clipsToBounds = true
        
        tintColor = UIColor.gray
        contentMode = .scaleAspectFill
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
