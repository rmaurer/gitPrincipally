//
//  Compare_4_TotalPaid.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 11/1/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore

class Compare_4_TotalPaid: UIView {

    var principallyGreenColor = UIColor(red: 30/255, green: 149/255, blue: 127/255, alpha: 1)
    
    var scenarioArray : [Scenario]? = nil
    
    func getTotalPayment(sArray:[Scenario])->[Double]{
        var returnArray = [Double]()
        for scenario in sArray{
            let concatPayment = scenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
            let lastPayment = concatPayment.lastObject as! MonthlyPayment
            returnArray.append(lastPayment.totalPrincipalSoFar.doubleValue + lastPayment.totalInterestSoFar.doubleValue)
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
            let totalPaymentArray :[Double] = self.getTotalPayment(scenarioArray!)
            let maxHeightInDollars = maxElement(totalPaymentArray) * 1.2
            
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
                let topY = convertNumberToYCoordinate(totalPaymentArray[index])
                
                let context = UIGraphicsGetCurrentContext()
                CGContextSetLineWidth(context, 4.0)
                CGContextSetStrokeColorWithColor(context,
                    principallyGreenColor.CGColor)
                let rectangle = CGRectMake(startX,topY,lineWidth,height-topY)
                CGContextAddRect(context, rectangle)
                CGContextStrokePath(context)
                CGContextSetFillColorWithColor(context,
                    principallyGreenColor.CGColor)
                CGContextFillRect(context, rectangle)
                
                var roundTotal = floor(totalPaymentArray[index] * 100) / 100
                
                var s: NSString = "\(scenarioArray![index].name): $\(roundTotal) in full"
                let fieldFont = UIFont(name: "Helvetica Neue", size: 14)
                s.drawWithBasePoint(CGPointMake(startX+lineWidth, bounds.height-20), angle: CGFloat(-M_PI_2), font: fieldFont!)
                
            }
            
            
            
            //s.drawInRect(CGRectMake(20.0, 140.0, 300.0, 48.0), withAttributes: attributes as [NSObject : AnyObject])
            
            
            
            
            //Start here: you want to draw a rectangle for each of total principal / total interst, etc.
        }
    }
}

