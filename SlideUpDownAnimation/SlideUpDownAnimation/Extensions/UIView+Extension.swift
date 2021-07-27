//
//  UIView+Extension.swift
//  PanGesture
//
//  Created by mind-0023 on 22/07/21.
//

import UIKit

extension UIView {

    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame = CGRect(x: xPos, y: yPos, width: newValue, height: self.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame = CGRect(x: xPos, y: yPos, width: self.width, height: newValue)
        }
    }
    
    var xPos: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: yPos, width: self.width, height: self.height)
        }
    }
    
    var yPos: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame = CGRect(x: xPos, y: newValue, width: self.width, height: self.height)
        }
    }
    
    var origin: CGPoint { return self.frame.origin }
    var size: CGSize { return self.frame.size }

    var minX: CGFloat { return self.frame.minX }
    var maxX: CGFloat { return self.frame.maxX }
    var midX: CGFloat { return self.frame.midX }
    var minY: CGFloat { return self.frame.minY }
    var maxY: CGFloat { return self.frame.maxY }
    var midY: CGFloat { return self.frame.midY }
}

extension UIView {

    private static let lineDashPattern: [NSNumber] = [7, 3]
    private static let lineDashWidth: CGFloat = 3.0

    func makeDashedBorderLine() {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = UIView.lineDashWidth
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineDashPattern = UIView.lineDashPattern
        path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.height/2),
                                CGPoint(x: bounds.maxX, y: bounds.height/2)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
