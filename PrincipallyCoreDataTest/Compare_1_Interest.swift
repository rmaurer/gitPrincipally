//
//  Compare_1_Interest.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 11/1/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore

class Compare_1_Interest: UIView {

    var scenarioArray : [Scenario]? = nil
    
    func getTotalInterest(sArray:[Scenario])->[Double]{
        var returnArray = [Double]()
        for scenario in sArray{
            //START HERE: why isn't this working
            println(scenario.name)
            let concatPayment = scenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
            let lastPayment = concatPayment.lastObject as! MonthlyPayment
            println(lastPayment.totalInterestSoFar)
            returnArray.append(lastPayment.totalInterestSoFar.doubleValue)
        }
        return returnArray
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        println("COMPARE 1 Draw Rect was called")
        if scenarioArray != nil {
            let height = rect.height
            var blockWidth = rect.width / CGFloat(scenarioArray!.count)
            var lineWidth = blockWidth / 3
            let totalInterestArray :[Double] = self.getTotalInterest(scenarioArray!)
            let maxHeightInDollars = maxElement(totalInterestArray) * 1.2
            
            var convertNumberToYCoordinate = { (graphPoint:Double) -> CGFloat in
                var y:CGFloat = CGFloat(graphPoint) /
                    CGFloat(maxHeightInDollars) * height
                y = height - y // Flip the graph
                return y
            }
            let context = UIGraphicsGetCurrentContext()
            
            for index in 0...scenarioArray!.count - 1 {
                
                let startX = CGFloat(lineWidth) + (blockWidth * CGFloat(index))
                //let endX = CGFloat(lineWidth * 2) + (blockWidth * CGFloat(index))
                let topY = convertNumberToYCoordinate(totalInterestArray[index])

                let context = UIGraphicsGetCurrentContext()
                CGContextSetLineWidth(context, 4.0)
                CGContextSetStrokeColorWithColor(context,
                    UIColor.redColor().CGColor)
                let rectangle = CGRectMake(startX,topY,lineWidth,height-topY)
                CGContextAddRect(context, rectangle)
                CGContextStrokePath(context)
                CGContextSetFillColorWithColor(context,
                    UIColor.redColor().CGColor)
                CGContextFillRect(context, rectangle)
                
                
                
                
            }
            /*var s: NSString = "Whereof we cannot speak, thereof we must remain silent."
            // set the text color to dark gray
            let fieldColor: UIColor = UIColor.darkGrayColor()
            
            // set the font to Helvetica Neue 18
            let fieldFont = UIFont(name: "Helvetica Neue", size: 18)
            
            // set the line spacing to 6
            var paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = 6.0
            
            // set the Obliqueness to 0.1
            var skew = 0.1
            
            var attributes: NSDictionary = [
                NSForegroundColorAttributeName: fieldColor,
                NSParagraphStyleAttributeName: paraStyle,
                NSObliquenessAttributeName: skew,
                NSFontAttributeName: fieldFont!
            ]*/
            var s: NSString = "Whereof we cannot speak, thereof we must remain silent."
            let fieldFont = UIFont(name: "Helvetica Neue", size: 14)
            
            s.drawWithBasePoint(CGPointMake(bounds.width/2, bounds.height/2), angle: CGFloat(-M_PI_2), font: fieldFont!)
            
            //s.drawInRect(CGRectMake(20.0, 140.0, 300.0, 48.0), withAttributes: attributes as [NSObject : AnyObject])
            
            
            
            
            //Start here: you want to draw a rectangle for each of total principal / total interst, etc.
        }
    }
    

}

extension NSString {
    
    func drawWithBasePoint(basePoint:CGPoint, angle:CGFloat, font:UIFont) {
        
        var attrs: NSDictionary = [
            NSFontAttributeName: font
        ]
        
        var textSize:CGSize = self.sizeWithAttributes(attrs as [NSObject : AnyObject])
        
        // sizeWithAttributes is only effective with single line NSString text
        // use boundingRectWithSize for multi line text
        
        var context: CGContextRef =   UIGraphicsGetCurrentContext()
        
        var t:CGAffineTransform   =   CGAffineTransformMakeTranslation(basePoint.x, basePoint.y)
        var r:CGAffineTransform   =   CGAffineTransformMakeRotation(angle)
        
        
        CGContextConcatCTM(context, t)
        CGContextConcatCTM(context, r)
        
        
        self.drawAtPoint(CGPointMake(-1 * textSize.width / 2, -1 * textSize.height / 2), withAttributes: attrs as [NSObject : AnyObject])
        
        
        CGContextConcatCTM(context, CGAffineTransformInvert(r))
        CGContextConcatCTM(context, CGAffineTransformInvert(t))
        
        
    }
    
    
}
