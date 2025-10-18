//
//  DetailsLabel.swift
//  HashChat
//
//  Created by shilani on 01/08/2024.
//

import UIKit

class DetailsLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
//    convenience init() {
//        self.init(frame: .zero)
//    }
//    
    
    private func configure() {
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
    }

}
