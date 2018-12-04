//
//  TimeView.swift
//  Here
//
//  Created by Joel Klabo on 12/4/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

class TimeView: UIView {

    static var sampleCount = 90
    
    // One bar every 0.1s, max 9s (9 / 0.1 = 90)
    // width will be divided into 90 segments
    // each segment will have a value (starting at 0.0)
    // representing the magnitude of the audio recording
    var samples: [CGFloat] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Fill backgound
        let path = UIBezierPath(rect: rect)
        UIColor.white.setFill()
        path.fill()
        
        // Draw divider
        let dividerPath = UIBezierPath()
        let dividerY = rect.height / 2
        let startX: CGFloat = 0
        let endX = rect.width
        let startPoint = CGPoint(x: startX, y: dividerY)
        let endPoint = CGPoint(x: endX, y: dividerY)
        dividerPath.move(to: startPoint)
        dividerPath.addLine(to: endPoint)
        UIColor.blue.setStroke()
        dividerPath.stroke()
        
        // Draw Samples
        let deltaXPerSample = rect.width / CGFloat(TimeView.sampleCount)
        let centerY = rect.height / 2
        for (index, sample) in samples.enumerated() {
            let x = rect.width - (CGFloat(index) * deltaXPerSample)
            let yMagnitude = rect.height * sample
            let startPoint = CGPoint(x: x, y: centerY - (yMagnitude / 2))
            let endPoint = CGPoint(x: x, y: centerY + (yMagnitude / 2))
            let samplePath = UIBezierPath()
            samplePath.move(to: startPoint)
            samplePath.addLine(to: endPoint)
            UIColor.blue.setStroke()
            samplePath.stroke()
        }
    }

}
