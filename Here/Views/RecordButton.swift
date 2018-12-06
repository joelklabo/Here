//
//  RecordButton.swift
//  Here
//
//  Created by Joel Klabo on 12/4/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

extension UIControl.Event {
    static let record = UIControl.Event(rawValue: 0b0001 << 24)
    static let stop = UIControl.Event(rawValue: 0b0010 << 24)
}

class RecordButton: UIControl {

    private enum ButtonState {
        case record
        case stop
        
        func other() -> ButtonState {
            if self == .record {
                return .stop
            }
            return .record
        }
    }
    
    private var currentState: ButtonState = .record {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var outerCirclePath = UIBezierPath()
    @objc private let buttonShapeLayer = CAShapeLayer()
    
    private let outerLineWidth: CGFloat = 4
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(buttonShapeLayer)
        addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let height = bounds.height > bounds.width ? bounds.width : bounds.height
        let width = height
        let startX = bounds.midX - width/2
        let centeredRect = CGRect(x: startX, y: 0, width: width, height: height)
        
        let insetForLineWidth: CGFloat = outerLineWidth/2
        outerCirclePath = UIBezierPath(ovalIn: centeredRect.insetBy(dx: insetForLineWidth, dy: insetForLineWidth))
        outerCirclePath.lineWidth = outerLineWidth
        UIColor.black.setStroke()
        outerCirclePath.stroke()
        
        switch currentState {
        case .record:
            let innerCircleInset: CGFloat = 8
            let inset = centeredRect.insetBy(dx: innerCircleInset, dy: innerCircleInset)
            buttonShapeLayer.path = UIBezierPath(roundedRect: inset, cornerRadius: inset.width/2).cgPath
        case .stop:
            let roundedRectInset: CGFloat = 23
            let cornerRadius: CGFloat = 10
            let inset = centeredRect.insetBy(dx: roundedRectInset, dy: roundedRectInset)
            buttonShapeLayer.path = UIBezierPath(roundedRect: inset, cornerRadius: cornerRadius).cgPath
        }
        
        buttonShapeLayer.fillColor = UIColor.red.cgColor
    }
    
    private func animateToggle() {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = buttonShapeLayer.path
        animation.toValue = currentState.other()
        animation.duration = 0.1
        buttonShapeLayer.add(animation, forKey: animation.keyPath)
        currentState = currentState.other()
    }
    
    @objc private func handleAction() {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = buttonShapeLayer.path
        animation.toValue = currentState.other()
        animation.duration = 0.1
        buttonShapeLayer.add(animation, forKey: animation.keyPath)
        currentState = currentState.other()
        
        switch currentState {
        case .record:
            sendActions(for: .stop)
        case .stop:
            sendActions(for: .record)
        }
    }
}
