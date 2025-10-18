//
//  AttributedButton.swift
//  HashChat
//
//  Created by shilani on 01/10/2024.
//

import UIKit

class AttributedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String){
        self.init(frame: .zero)
        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.red])
            setAttributedTitle(attributedString, for: .normal)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.secondaryLabel, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    }

    
    
    
}
