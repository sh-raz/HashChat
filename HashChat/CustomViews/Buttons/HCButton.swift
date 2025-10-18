//
//  CustomButton.swift
//  HashChat
//
//  Created by shilani on 09/07/2024.
//

import UIKit

class HCButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    convenience init(title: String, theme: Theme) {
        self.init(frame: .zero)
        self.backgroundColor = theme.mainColor
        setTitleColor(theme.accentColor, for: .normal)
        setTitle(title, for: .normal)
        configure()
    }
    
    
    private func configure() {
        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        layer.cornerRadius  = 15
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowRadius = 15
        translatesAutoresizingMaskIntoConstraints = false
    }
}
