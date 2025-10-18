//
//  MessageLabel.swift
//  HashChat
//
//  Created by shilani on 02/09/2024.
//

import UIKit

class MessageLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        font = UIFont.preferredFont(forTextStyle: .body)
        tintColor = .label
        textAlignment = .left
        numberOfLines = 0
        lineBreakMode = .byTruncatingTail
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        
        setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        //setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
