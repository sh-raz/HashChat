//
//  HelperButton.swift
//  HashChat
//
//  Created by shilani on 07/09/2024.
//

import UIKit

class HelperButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: ContentHorizontalAlignment ){
        self.init(frame: .zero)
        self.contentHorizontalAlignment = textAlignment
    }
    convenience init(title: String){
        self.init(frame: .zero)
        setTitle(title, for: .normal)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.secondaryLabel, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    }
}
