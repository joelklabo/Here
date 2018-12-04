//
//  RecordButton.swift
//  Here
//
//  Created by Joel Klabo on 12/4/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

class RecordButton: UIControl {

    enum ButtonState {
        case record
        case stop
        
        func other() -> ButtonState {
            if self == .record {
                return .stop
            }
            return .record
        }
    }
    
    var currentState: ButtonState = .stop {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var outerCirclePath = UIBezierPath()
    @objc let buttonShapeLayer = CAShapeLayer()
    
    let outerLineWidth: CGFloat = 4
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(buttonShapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let insetForLineWidth: CGFloat = outerLineWidth/2
        outerCirclePath = UIBezierPath(ovalIn: bounds.insetBy(dx: insetForLineWidth, dy: insetForLineWidth))
        outerCirclePath.lineWidth = outerLineWidth
        UIColor.white.setStroke()
        outerCirclePath.stroke()
        
        switch currentState {
        case .record:
            let innerCircleInset: CGFloat = 8
            let inset = bounds.insetBy(dx: innerCircleInset, dy: innerCircleInset)
            buttonShapeLayer.path = UIBezierPath(roundedRect: inset, cornerRadius: inset.width/2).cgPath
        case .stop:
            let roundedRectInset: CGFloat = 28
            let cornerRadius: CGFloat = 10
            let inset = bounds.insetBy(dx: roundedRectInset, dy: roundedRectInset)
            buttonShapeLayer.path = UIBezierPath(roundedRect: inset, cornerRadius: cornerRadius).cgPath
        }
        
        buttonShapeLayer.fillColor = UIColor.red.cgColor
    }
    
    func animateToggle() {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = buttonShapeLayer.path
        animation.toValue = currentState.other()
        animation.duration = 0.1
        buttonShapeLayer.add(animation, forKey: animation.keyPath)
        currentState = currentState.other()
    }
}
