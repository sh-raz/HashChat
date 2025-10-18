//
//  MessageTextField.swift
//  HashChat
//
//  Created by shilani on 03/09/2024.
//

import UIKit

class MessageTextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }

       override func editingRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }

       override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }


    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.systemGray4.cgColor
        backgroundColor = .tertiarySystemBackground
        layer.borderWidth = 2.0
        layer.cornerRadius = 20
        
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 20
        tintColor = UIColor.lightGray
        
        font = UIFont.preferredFont(forTextStyle: .body)
        
        
    }

    func set(placeHolder: String) {
        configure()
        self.placeholder = placeHolder
    }
    
}
