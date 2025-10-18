//
//  LoadingCell.swift
//  HashChat
//
//  Created by shilani on 17/08/2024.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    static let reuseID  = "LoadingCell"
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    var activityIndicatorCenterConstraint: NSLayoutConstraint?
    var activityIndicatorCenterWithKeyboardConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        contentView.addSubview(activityIndicator)
        activityIndicator.color = .red
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 30),
            activityIndicator.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setIndicatoreViewPosition(constant: CGFloat){
        if constant != 0 {
            activityIndicatorCenterWithKeyboardConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: constant / 2)
            activityIndicatorCenterWithKeyboardConstraint?.isActive = true
            activityIndicatorCenterConstraint?.isActive = false
        }else{
            activityIndicatorCenterConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            activityIndicatorCenterConstraint?.isActive = true
            activityIndicatorCenterWithKeyboardConstraint?.isActive = false
        }
        layoutIfNeeded()
    }
    
    
    
}
