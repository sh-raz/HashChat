//
//  UserDetailsStackView.swift
//  HashChat
//
//  Created by shilani on 01/08/2024.
//

import UIKit

class UserDetailsStackView: UIStackView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        required init(coder: NSCoder) {
            super.init(coder: coder)
            configure()
        }
    
    
    let nameLabel = TitleLabel(fontSize: 25,textAlignment: .left)
    let detailLabel = DetailsLabel()
    
    
    
        private func configure() {
            self.addArrangedSubview(nameLabel)
            self.addArrangedSubview(detailLabel)
            
            // Configure stack view properties
            self.axis = .vertical
            self.spacing = 0
            self.alignment = .fill
            self.distribution = .fillProportionally
            translatesAutoresizingMaskIntoConstraints = false

            
            NSLayoutConstraint.activate([
                //nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
                //nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1),
                nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                //detailLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 1),
                detailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                //detailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1)
            
            ])
            
        }
    
    func set(nameLabel: String, detailLabel: String) {
        self.nameLabel.text = nameLabel
        self.detailLabel.text = detailLabel

    }
    
    
    }
