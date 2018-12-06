//
//  DeleteButton.swift
//  Here
//
//  Created by Joel Klabo on 12/6/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

extension UIControl.Event {
    static let delete = UIControl.Event(rawValue: 0b0100 << 24)
}

class DeleteButton: UIControl {
    
    static let defaultSize = CGSize(width: 35, height: 35)
    
    let lineWidth: CGFloat = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addTarget(self, action: #selector(handleAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let width = DeleteButton.defaultSize.width
        let height = DeleteButton.defaultSize.height
        let x = bounds.midX - width / 2
        let y = bounds.midY - height / 2
        let drawingRect = CGRect(x: x,
                                 y: y,
                                 width: width,
                                 height: height)
        
        let circle = UIBezierPath(ovalIn: drawingRect)
        UIColor.red.setFill()
        circle.fill()
        
        let translationDistance = width / 5
        let center = CGPoint(x: drawingRect.midX, y: drawingRect.midY)
        
        let leftTop = CGPoint(x: center.x - translationDistance, y: center.y - translationDistance)
        let rightTop = CGPoint(x: center.x + translationDistance, y: center.y - translationDistance)
        let leftBottom = CGPoint(x: center.x - translationDistance, y: center.y + translationDistance)
        let rightBottom = CGPoint(x: center.x + translationDistance, y: center.y + translationDistance)
        
        let xPath = UIBezierPath()
        xPath.move(to: center)
        xPath.addLine(to: leftTop)
        xPath.move(to: center)
        xPath.addLine(to: rightTop)
        xPath.move(to: center)
        xPath.addLine(to: leftBottom)
        xPath.move(to: center)
        xPath.addLine(to: rightBottom)
        
        UIColor.white.setStroke()
        xPath.lineWidth = lineWidth
        xPath.lineCapStyle = .round
        xPath.stroke()
    }
}

extension DeleteButton {
    @objc private func handleAction() {
        sendActions(for: .delete)
    }
}
