//
//  EmptyCell.swift
//  HashChat
//
//  Created by shilani on 06/08/2024.
//

import UIKit

class EmptyCell: UITableViewCell {
    
    static let reuseID  = "EmptyMessagesCell"
    let emptyMessageView = EmptyMessagesView(frame: .zero)
    let messageLabel = TitleLabel(fontSize: 18, textAlignment: .left)
    let actionButton = HCButton(title: "OK", theme: .orange)
    
    var messageViewCenterConstraint: NSLayoutConstraint?
    var messageViewCenterWithKeyboardConstraint: NSLayoutConstraint?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        contentView.addSubview(emptyMessageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(actionButton)
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        configureEmptyView()
        configureMessageLabel()
        configureActionButton()
    }
    

    
    
    
    func setEmptyViewPosition(constant: CGFloat) {
        if constant != 0 {
            messageViewCenterWithKeyboardConstraint = NSLayoutConstraint(item: emptyMessageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: constant / 2)
            messageViewCenterWithKeyboardConstraint?.isActive = true
            messageViewCenterConstraint?.isActive = false
        }else{
            messageViewCenterConstraint = NSLayoutConstraint(item: emptyMessageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            messageViewCenterConstraint?.isActive = true
            messageViewCenterWithKeyboardConstraint?.isActive = false
        }
        layoutIfNeeded()
    }
    
    
    func configureEmptyView() {
        NSLayoutConstraint.activate([
            //emptyMessageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emptyMessageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyMessageView.widthAnchor.constraint(equalToConstant: 220),
            emptyMessageView.heightAnchor.constraint(equalToConstant: 200)  //❤️I LOVE YOU SO MUCH MOMMY!
        ])
    }
    func configureMessageLabel() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: emptyMessageView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: emptyMessageView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: emptyMessageView.trailingAnchor, constant: -10),
            messageLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    func configureActionButton() {
        actionButton.setTitle("Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(removeFromSuperView), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: emptyMessageView.bottomAnchor, constant: -10),
            actionButton.leadingAnchor.constraint(equalTo: emptyMessageView.leadingAnchor, constant: 10),
            actionButton.trailingAnchor.constraint(equalTo: emptyMessageView.trailingAnchor, constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    //  func adjustMessageViewPosition(keyboardHeight: CGFloat){
    //        NSLayoutConstraint.activate([
    //            emptyMessageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: keyboardHeight / 2),
    //            emptyMessageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
    //            emptyMessageView.widthAnchor.constraint(equalToConstant: 220),
    //            emptyMessageView.heightAnchor.constraint(equalToConstant: 200)
    //        ])
    //        configureMessageLabel()            //❤️I LOVE YOU SO MUCH MOMMY!
    //        configureActionButton()
    //        self.layoutSubviews()
    //    }
    
    
    
    @objc func removeFromSuperView() {
        self.removeFromSuperview()
    }
    
}
