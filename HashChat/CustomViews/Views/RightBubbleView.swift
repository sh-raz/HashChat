//
//  BubbleView2.swift
//  HashChat
//
//  Created by shilani on 26/10/2024.
//

import UIKit

class RightBubbleView: UIView {
    var label = MessageLabel()
    let padding: CGFloat = 15
    var cornerRadius: CGFloat = 20
    let bubbleTail: CGFloat = 8
    
    
    var theme: Theme = .lightYellow
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String, style: MessageStyle, theme: Theme){
        self.init(frame: .zero)
        self.label.text = text
        self.theme = theme
    }
    
    func configure() {
        self.addSubview(label)
        label.textColor = theme.accentColor
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding)
        ])
    }
  
    
    func set(text: String) {
        self.label.text = text
        setNeedsDisplay()
    }
    
  
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let startPoint = CGPoint(x: rect.maxX , y: rect.maxY)
    
        let bottomLeft = CGPoint(x: rect.minX + cornerRadius, y: rect.maxY)
        let bottomLeftArcCenter = CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius)
       
        let topLeft = CGPoint(x: rect.minX, y: rect.minY + cornerRadius)
        let topLeftArcCenter = CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius)
        
        let topRight = CGPoint(x: rect.maxX - cornerRadius - bubbleTail, y: rect.minY)
        let topRightArcCenter = CGPoint(x: rect.maxX - cornerRadius - bubbleTail, y: rect.minY + cornerRadius)
        
        let bottomRight = CGPoint(x: rect.maxX - bubbleTail, y: rect.maxY - bubbleTail)
        let bottomRightArcCenter = CGPoint(x: rect.maxX, y: rect.maxY - bubbleTail)

        path.move(to: startPoint)
        path.addLine(to: bottomLeft)
        path.addArc(withCenter: bottomLeftArcCenter, radius: cornerRadius, startAngle: CGFloat(0.5 * .pi), endAngle: CGFloat.pi, clockwise: true)
        path.addLine(to: topLeft)
        path.addArc(withCenter: topLeftArcCenter, radius: cornerRadius, startAngle: CGFloat(1.0 * .pi), endAngle: (1.5 * .pi), clockwise: true)
        path.addLine(to: topRight)
        path.addArc(withCenter: topRightArcCenter, radius: cornerRadius, startAngle: (1.5 * .pi), endAngle: 0, clockwise: true)
        path.addLine(to: bottomRight)
        path.addArc(withCenter: bottomRightArcCenter, radius: bubbleTail, startAngle: CGFloat(1.0 * .pi) , endAngle: (1.5 * .pi), clockwise: false)
        path.close()
        theme.mainColor.setFill()
        path.fill()
        //UIColor.black.setStroke()
        //path.lineWidth = 1
        //path.stroke()
    }

}
