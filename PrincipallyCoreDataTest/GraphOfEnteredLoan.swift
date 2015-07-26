//
//  GraphOfEnteredLoan.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/8/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class GraphOfEnteredLoan: UIView { //add IBDesignable if you want to see updates within the story board.

        var enteredLoan:Loan? = nil
        @IBInspectable var borderColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 1)
        @IBInspectable var startColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 0.7)
        @IBInspectable var endColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 0.6)
        let alwaysX = CGFloat()
        let alwaysY = CGFloat()
        let CAWhiteLine = CALayer()
    
        override func drawRect(rect: CGRect) {
            
            var principalGraphPoints : [Double] = enteredLoan!.makeArrayOfAllPrincipalPayments()
            var interestGraphPoints : [Double] = enteredLoan!.makeArrayOfAllInterestPayments()
            let width = rect.width
            let height = rect.height
            
            let context = UIGraphicsGetCurrentContext()
            CGContextSetLineWidth(context, 12.0)
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
            
            
            //set up background clipping area
            var path = UIBezierPath(rect: rect)
            CGContextStrokeRect(context, rect)
            
            
           // var path = UIBezierPath(roundedRect: rect,
           //     byRoundingCorners: UIRectCorner.AllCorners,
           //     cornerRadii: CGSize(width: 8.0, height: 8.0))
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
            
            //calculate the x point
            
            let margin:CGFloat = 20.0
            var columnXPoint = { (column:Int) -> CGFloat in
                //Calculate gap between points
                let spacer = (width - margin*2 - 4) /
                    CGFloat((principalGraphPoints.count - 1))
                var x:CGFloat = CGFloat(column) * spacer
                x += margin + 2
                return x
            }
            
            // calculate the y point
            
            let topBorder:CGFloat = 60
            let bottomBorder:CGFloat = 50
            let graphHeight = height - topBorder - bottomBorder
            let maxValue = maxElement(principalGraphPoints)
            var columnYPoint = { (graphPoint:Double) -> CGFloat in
                var y:CGFloat = CGFloat(graphPoint) /
                    CGFloat(maxValue) * graphHeight
                y = graphHeight + topBorder - y // Flip the graph
                return y
            }
            
            // draw the line graph
            
            UIColor.blueColor().setFill()
            UIColor.blueColor().setStroke()
            
            //set up the points line
            var graphPath = UIBezierPath()
            //go to start of line
            graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
                y:columnYPoint(principalGraphPoints[0])))
            
            //add points for each item in the graphPoints array
            //at the correct (x, y) for the point
            for i in 1..<principalGraphPoints.count {
                let nextPoint = CGPoint(x:columnXPoint(i),
                    y:columnYPoint(principalGraphPoints[i]))
                graphPath.addLineToPoint(nextPoint)
            }
            //draw the line on top of the clipped gradient
            graphPath.lineWidth = 2.0
            graphPath.stroke()
            //DrawtheInterest
            //calculate the x point
            
            var columnXPoint2 = { (column:Int) -> CGFloat in
                //Calculate gap between points
                let spacer = (width - margin*2 - 4) /
                    CGFloat((principalGraphPoints.count - 1))
                var x:CGFloat = CGFloat(column) * spacer
                x += margin + 2
                return x
            }
            
            // calculate the y point
            
            var columnYPoint2 = { (graphPoint:Double) -> CGFloat in
                var y:CGFloat = CGFloat(graphPoint) /
                    CGFloat(maxValue) * graphHeight
                y = graphHeight + topBorder - y // Flip the graph
                return y
            }
            
            UIColor.redColor().setFill()
            UIColor.redColor().setStroke()
            
            var interestGraphPath = UIBezierPath()
            
            //set up the points line
            
            //go to start of line
            interestGraphPath.moveToPoint(CGPoint(x:columnXPoint2(0),
                y:columnYPoint2(interestGraphPoints[0])))
            
            //add points for each item in the graphPoints array
            //at the correct (x, y) for the point
            for i in 1..<principalGraphPoints.count {
                let nextPoint = CGPoint(x:columnXPoint2(i),
                    y:columnYPoint2(interestGraphPoints[i]))
                interestGraphPath.addLineToPoint(nextPoint)
            }
            //draw the line on top of the clipped gradient
            interestGraphPath.lineWidth = 2.0
            interestGraphPath.stroke()
            
            ///Draw line to mark one particular payment
            
            //self.whiteLine.speed = 0.0
        
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
