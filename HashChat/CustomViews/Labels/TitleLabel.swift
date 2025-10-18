//
//  TitleLabel.swift
//  HashChat
//
//  Created by shilani on 01/08/2024.
//

import UIKit

class TitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    convenience init(fontSize: CGFloat, textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        self.textAlignment = textAlignment
    }
    
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
