//
//  CustomTextField.swift
//  HashChat
//
//  Created by shilani on 10/07/2024.
//

import UIKit

class CustomTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String){
        self.init(frame: .zero)
        self.placeholder = placeholder
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
        
        layer.cornerRadius = 20
        backgroundColor = UIColor.secondarySystemBackground
        textColor = .label
        font = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
}
