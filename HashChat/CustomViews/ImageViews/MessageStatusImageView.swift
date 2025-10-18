//
//  MessageStatusImageView.swift
//  HashChat
//
//  Created by shilani on 19/08/2024.
//

import UIKit

enum MessageStatus {
    case sent
    case delivered
    case read
}

class MessageStatusImageView: UIImageView {
    //let cache               = NetworkManager.shared.cache
    let placeholderImage = UIImage(systemName: "checkmark.circle.badge.questionmark")
    var messageStatus: MessageStatus = .sent
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 15
        clipsToBounds = true
        tintColor = UIColor.gray
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    var shownImage : UIImage {
        switch messageStatus {
        case .sent:
            return UIImage(systemName: "arrow.up.message") ?? UIImage.add
        case .delivered:
            return UIImage(systemName: "checkmark.message") ?? UIImage.add
        case .read:
            return UIImage(named: "checkmark.message.fill") ?? UIImage.add
        }
    }

}
