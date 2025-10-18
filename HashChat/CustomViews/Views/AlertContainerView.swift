//
//  AlertContainerView.swift
//  HashChat
//
//  Created by shilani on 07/09/2024.
//

import UIKit

class AlertContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
