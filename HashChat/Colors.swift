//
//  Colors.swift
//  HashChat
//
//  Created by shilani on 24/09/2024.
//

import UIKit

enum Theme: String {
    case lightPurple
    case darkGray
    case lightGreen
    case orange
    case orange2
    case lightYellow
    case pink
    case yellow
    case purple
    case blue
    
    
    
    var accentColor: UIColor {
        switch self {
        case .lightPurple, .lightYellow, .lightGreen:
            return .black
        case .darkGray, .orange, .orange2:
            return .white
        case .pink:
            return .black
        case .yellow:
            return .black
        case .purple:
            return .white
        case .blue:
            return .black
        }
    }
   
    var mainColor: UIColor {
        return UIColor(named: self.rawValue) ?? .red
    }
    
}

