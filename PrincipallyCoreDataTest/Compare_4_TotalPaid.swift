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
    var scenarioArray : [Scenario]? = nil
    
    func getTotalPayment(sArray:[Scenario])->[Double]{
        var returnArray = [Double]()
        for scenario in sArray{
            //let concatPayment = scenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
            //let lastPayment = concatPayment.lastObject as! MonthlyPayment
            let vvalue = scenario.nnewTotalScenarioInterest.doubleValue + scenario.nnewTotalPrincipal.doubleValue + scenario.forgivenBalance.doubleValue
            returnArray.append(vvalue)
            
            //lastPayment.totalPrincipalSoFar.doubleValue + lastPayment.totalInterestSoFar.doubleValue + scenario.forgivenBalance.doubleValue)
        }
        return returnArray
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        //println("COMPARE 1 Draw Rect was called")
        if scenarioArray != nil {
            let height = rect.height
            var blockWidth = rect.width / CGFloat(scenarioArray!.count)
            var lineWidth = blockWidth / 3
            
            let maxHeightInDollars = maxElement(self.getTotalPayment(scenarioArray!)) * 1.1
            
            var convertNumberToYCoordinate = { (graphPoint:Double) -> CGFloat in
                var y:CGFloat =  height * (CGFloat(graphPoint) /
                    CGFloat(maxHeightInDollars))
                //y = height - y // Flip the graph
                return y
            }
            let context = UIGraphicsGetCurrentContext()
            
            for index in 0...scenarioArray!.count - 1 {
                
                
                var thisScenariosColor = UIColor(red: CGFloat(scenarioArray![index].red.doubleValue/255.0), green: CGFloat(scenarioArray![index].green.doubleValue/255.0), blue: CGFloat(scenarioArray![index].blue.doubleValue/255.0), alpha: 1)
                var thisScenariosColorFaded = UIColor(red: CGFloat(scenarioArray![index].red.doubleValue/255.0), green: CGFloat(scenarioArray![index].green.doubleValue/255.0), blue: CGFloat(scenarioArray![index].blue.doubleValue/255.0), alpha: 0.5)
                
                let startX = CGFloat(lineWidth) + (blockWidth * CGFloat(index))
                //let endX = CGFloat(lineWidth * 2) + (blockWidth * CGFloat(index))
                let topPrincipalY = convertNumberToYCoordinate(scenarioArray![index].nnewTotalPrincipal.doubleValue)
                let topInterestY = convertNumberToYCoordinate(scenarioArray![index].nnewTotalScenarioInterest.doubleValue)
                let topWithCancelledY = convertNumberToYCoordinate(scenarioArray![index].forgivenBalance.doubleValue)
                
                let context = UIGraphicsGetCurrentContext()
                CGContextSetLineWidth(context, 4.0)
                CGContextSetStrokeColorWithColor(context,
                    thisScenariosColorFaded.CGColor)
                
                
                let principalRectangle = CGRectMake(startX, height - topPrincipalY, lineWidth, topPrincipalY)//CGRectMake(startX,topPrincipalY,lineWidth,height-topPrincipalY)
                CGContextAddRect(context, principalRectangle)
                CGContextStrokePath(context)
                CGContextSetFillColorWithColor(context,
                    thisScenariosColorFaded.CGColor)
                CGContextFillRect(context, principalRectangle)
                
                let interestRectangle = CGRectMake(startX, height - (topPrincipalY + topInterestY), lineWidth, topInterestY)//CGRectMake(startX,topInterestY,lineWidth,(height - topInterestY))
                CGContextAddRect(context, interestRectangle)
                CGContextStrokePath(context)
                CGContextSetFillColorWithColor(context,
                    thisScenariosColorFaded.CGColor)
                CGContextFillRect(context, interestRectangle)
                
                
                let cancelledRectangle = CGRectMake(startX, height - (topPrincipalY + topInterestY + topWithCancelledY), lineWidth, topWithCancelledY)//CGRectMake(startX,topWithCancelledY,lineWidth,height-topWithCancelledY)
                CGContextAddRect(context, cancelledRectangle)
                CGContextStrokePath(context)
                CGContextSetFillColorWithColor(context,
                    thisScenariosColor.CGColor)
                CGContextFillRect(context, cancelledRectangle)
                
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .CurrencyStyle
                
                var forgivenBalance = scenarioArray![index].forgivenBalance
                
                var s: NSString = "\(scenarioArray![index].name): \(numberFormatter.stringFromNumber(forgivenBalance)!) forgiven balance"
                let fieldFont = UIFont(name: "Helvetica Neue", size: 14)
                s.drawWithBasePoint(CGPointMake(startX+lineWidth, bounds.height-20), angle: CGFloat(-M_PI_2), font: fieldFont!)
                
            }
            
        }
    }

}

