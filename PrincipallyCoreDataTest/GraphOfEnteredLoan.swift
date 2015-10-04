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
    
        let alwaysX = CGFloat()
        let alwaysY = CGFloat()

    
        @IBInspectable var startColor: UIColor = UIColor.redColor()
        @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
        @IBInspectable var pStartColor: UIColor = UIColor.greenColor()
        @IBInspectable var pEndColor: UIColor = UIColor.greenColor()
    
        @IBInspectable var bStartColor: UIColor = UIColor.greenColor()
        @IBInspectable var bEndColor: UIColor = UIColor.greenColor()
    

        override func drawRect(rect: CGRect) {
            
            println("got into drawRect")
            
            if enteredLoan != nil {
            
            //var principalGraphPoints : [Double] = enteredLoan!.makeArrayOfAllPrincipalPayments()
            var totalGraphPoints : [Double] = enteredLoan!.makeArrayOfAllTotalPayments()
            var interestGraphPoints : [Double] = enteredLoan!.makeArrayOfAllInterestPayments()
            let width = rect.width
            let height = rect.height
            

            //set up background clipping area
            var path = UIBezierPath(roundedRect: rect,
                byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: 8.0, height: 8.0))
            path.addClip()
            
            //get context
            let context = UIGraphicsGetCurrentContext()
            
            //set up colors
            let colors = [startColor.CGColor, endColor.CGColor]
            let pcolors = [pStartColor.CGColor, pEndColor.CGColor]
            let bcolors = [bStartColor.CGColor, bEndColor.CGColor]
            
            //3 - set up the color space
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            //4 - set up the color stops
            let colorLocations:[CGFloat] = [0.0, 1.0]
            
            //5 - create the gradient
            let gradient = CGGradientCreateWithColors(colorSpace,
                colors,
                colorLocations)
            
            let pgradient = CGGradientCreateWithColors(colorSpace,
                pcolors,
                colorLocations)
            
            let bgradient = CGGradientCreateWithColors(colorSpace,
                bcolors,
                colorLocations)

            
            //6 - draw the gradient
            var startPoint = CGPoint.zeroPoint
            var endPoint = CGPoint(x:0, y:self.bounds.height)
            
            CGContextDrawLinearGradient(context,
                bgradient,
                startPoint,
                endPoint,
                0)
            
            //calculate the x point
            
            let margin:CGFloat = 0.0
            var columnXPoint = { (column:Int) -> CGFloat in
                //Calculate gap between points
                let spacer = (width - margin*2 - 4) /
                    CGFloat((interestGraphPoints.count - 1))
                var x:CGFloat = CGFloat(column) * spacer
                x += margin + 2
                return x
            }
            
            // calculate the y point
            
            let topBorder:CGFloat = 0
            let bottomBorder:CGFloat = 27
            let graphHeight = height - topBorder - bottomBorder
            let maxValue = maxElement(interestGraphPoints)
            let totalMaxValue = maxElement(totalGraphPoints)
            var columnYPoint = { (graphPoint:Double) -> CGFloat in
                var y:CGFloat = CGFloat(graphPoint) /
                    CGFloat(totalMaxValue) * graphHeight
                y = graphHeight + topBorder - y // Flip the graph
                return y
            }
            
            UIColor.whiteColor().setFill()
            UIColor.whiteColor().setStroke()
            
            var totalGraphPath = UIBezierPath()
            totalGraphPath.moveToPoint(CGPoint(x:columnXPoint(0),y:columnYPoint(totalGraphPoints[0])))
            
            for i in 1..<totalGraphPoints.count {
                let nextPoint = CGPoint(x:columnXPoint(i),
                    y:columnYPoint(totalGraphPoints[i]))
                totalGraphPath.addLineToPoint(nextPoint)
            }
            
            //1 - save the state of the context (commented out for now)
            CGContextSaveGState(context)
            
            //2 - make a copy of the path
            var totalClippingPath = totalGraphPath.copy() as! UIBezierPath
            
            //3 - add lines to the copied path to complete the clip area
            //3 - add lines to the copied path to complete the clip area
            totalClippingPath.addLineToPoint(CGPoint(
                x: columnXPoint(interestGraphPoints.count - 1),
                y:height-margin))
            totalClippingPath.addLineToPoint(CGPoint(
                x:columnXPoint(0),
                y:height-margin))
            totalClippingPath.closePath()
            // draw the line graph
            
            //4 - add the clipping path to the context
            totalClippingPath.addClip()
            
            let highestYPPoint = columnYPoint(totalMaxValue)
            startPoint = CGPoint(x:margin, y: highestYPPoint)
            endPoint = CGPoint(x:margin, y:self.bounds.height)
            
            CGContextDrawLinearGradient(context, pgradient, startPoint, endPoint, 0)
            CGContextRestoreGState(context)
            
            //draw the line on top of the clipped gradient
            totalGraphPath.lineWidth = 2.0
            totalGraphPath.stroke()
            
            ////start other line
            ////
            
            UIColor.whiteColor().setFill()
            UIColor.whiteColor().setStroke()
            
            //set up the points line
            var graphPath = UIBezierPath()
            //go to start of line
            graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
                y:columnYPoint(interestGraphPoints[0])))
            
            //add points for each item in the graphPoints array
            //at the correct (x, y) for the point
            for i in 1..<interestGraphPoints.count {
                let nextPoint = CGPoint(x:columnXPoint(i),
                    y:columnYPoint(interestGraphPoints[i]))
                graphPath.addLineToPoint(nextPoint)
                println(interestGraphPoints[i])
            }

            
            //1 - save the state of the context (commented out for now)
            CGContextSaveGState(context)
            
            //2 - make a copy of the path
            var clippingPath = graphPath.copy() as! UIBezierPath
            
            //3 - add lines to the copied path to complete the clip area
            clippingPath.addLineToPoint(CGPoint(
                x: columnXPoint(interestGraphPoints.count - 1),
                y:height-margin))
            clippingPath.addLineToPoint(CGPoint(
                x:columnXPoint(0),
                y:height-margin))
            clippingPath.closePath()
            
            //4 - add the clipping path to the context
            clippingPath.addClip()
            let highestYPoint = columnYPoint(maxValue)
            startPoint = CGPoint(x:margin, y: highestYPoint)
            endPoint = CGPoint(x:margin, y:self.bounds.height)
            
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
            CGContextRestoreGState(context)
            
            //draw the line on top of the clipped gradient
            graphPath.lineWidth = 2.0
            graphPath.stroke()

            
            //Draw horizontal graph lines on the top of everything
            var linePath = UIBezierPath()
                
            //
            var third = graphHeight / 4
            
            //top line
            linePath.moveToPoint(CGPoint(x:margin, y: third))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y:third))
            
            //center line
            linePath.moveToPoint(CGPoint(x:margin,
                y: third * 2))//graphHeight/2 + topBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin,
                y: third * 2))//graphHeight/2 + topBorder))
            
            //bottom line
            linePath.moveToPoint(CGPoint(x:margin,
                y: third * 3))//height - bottomBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin,
                y: third * 3))//height - bottomBorder))
            let color = UIColor(white: 1.0, alpha: 0.3)
            color.setStroke()
            
            linePath.lineWidth = 1.0
            linePath.stroke()
                
            }
            
            
    }

}
