//
//  GraphOfScenario.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class GraphOfScenario: UIView {

    var unsavedScenario:Scenario? = nil
    var defaultScenario:Scenario? = nil
    @IBInspectable var borderColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 1)
    @IBInspectable var startColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 0.7)
    @IBInspectable var endColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 0.6)
    let alwaysX = CGFloat()
    let alwaysY = CGFloat()
    let CAWhiteLine = CALayer()
    let newLine = CALayer()
    
    override func drawRect(rect: CGRect) {
        println("DrawRect was called")
        var defaultScenarioInterestGraphPoints : [Double] = defaultScenario!.makeArrayOfAllInterestPayments()
        var defaultScenarioTotalGraphPoints : [Double] = defaultScenario!.makeArrayOfTotalPayments()
        //var currentScenarioInterestGraphPoints : [Double] = currentScenario!.makeArrayOfAllInterestPayments()
        let width = rect.width
        let height = rect.height
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 12.0)
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        
        
        //Gradient.  First, set up background clipping area
        var path = UIBezierPath(rect: rect)
        CGContextStrokeRect(context, rect)
        path.addClip()
        //2 - get the current context
        let colors = [startColor.CGColor, endColor.CGColor]
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        //6 - draw the gradient
        var startPoint = CGPoint.zeroPoint
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            0)
        
        CAWhiteLine.frame = CGRectMake(22,0,4,CGFloat(rect.height))
        CAWhiteLine.backgroundColor = UIColor.whiteColor().CGColor
        
        self.layer.addSublayer(CAWhiteLine)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = 0 //NSValue(CGRect: CAWhiteLine.frame)
        animation.toValue = rect.width - 48 //NSValue(CGRect: CGRectMake(140,0,4,CGFloat(rect.height)))
        animation.duration = 1.0
        
        CAWhiteLine.addAnimation(animation, forKey: "animate transform animation")
        
        CAWhiteLine.speed = 0

        
    }

}
