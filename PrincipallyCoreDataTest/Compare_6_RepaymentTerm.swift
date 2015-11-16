//
//  Compare_6_RepaymentTerm.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 11/15/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class Compare_6_RepaymentTerm: UIView {

    
    
    
    var scenarioArray : [Scenario]? = nil
    
    func getMonthsInRepaymentArray(sArray:[Scenario])->[Double]{
        var returnArray = [Double]()
        for scenario in sArray{
            
            returnArray.append(scenario.nnewTotalScenarioMonths.doubleValue)
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
            //var initialpaymentArray = self.getInitialPaymentsArray(scenarioArray!)
            let maxHeightInMonths = maxElement(getMonthsInRepaymentArray(scenarioArray!)) * 1.1
            
            var convertNumberToYCoordinate = { (graphPoint:Double) -> CGFloat in
                var y:CGFloat =  height * (CGFloat(graphPoint) /
                    CGFloat(maxHeightInMonths))
                //y = height - y // Flip the graph
                return y
            }
            let context = UIGraphicsGetCurrentContext()
            
            for index in 0...scenarioArray!.count - 1 {
                
                
                var thisScenariosColor = UIColor(red: CGFloat(scenarioArray![index].red.doubleValue/255.0), green: CGFloat(scenarioArray![index].green.doubleValue/255.0), blue: CGFloat(scenarioArray![index].blue.doubleValue/255.0), alpha: 1)
                var thisScenariosColorFaded = UIColor(red: CGFloat(scenarioArray![index].red.doubleValue/255.0), green: CGFloat(scenarioArray![index].green.doubleValue/255.0), blue: CGFloat(scenarioArray![index].blue.doubleValue/255.0), alpha: 0.5)
                
                let startX = CGFloat(lineWidth) + (blockWidth * CGFloat(index))
                //let endX = CGFloat(lineWidth * 2) + (blockWidth * CGFloat(index))
                let topPayment = convertNumberToYCoordinate(scenarioArray![index].nnewTotalScenarioMonths.doubleValue)
                
                let context = UIGraphicsGetCurrentContext()
                CGContextSetLineWidth(context, 4.0)
                CGContextSetStrokeColorWithColor(context,
                    thisScenariosColorFaded.CGColor)
                
                
                let principalRectangle = CGRectMake(startX, height - topPayment, lineWidth, topPayment)//CGRectMake(startX,topPrincipalY,lineWidth,height-topPrincipalY)
                CGContextAddRect(context, principalRectangle)
                CGContextStrokePath(context)
                CGContextSetFillColorWithColor(context,
                    thisScenariosColor.CGColor)
                CGContextFillRect(context, principalRectangle)
                
                
                
               // var roundInitialPayment = floor(initialpaymentArray[index] * 100) / 100
                var years = floor(scenarioArray![index].nnewTotalScenarioMonths.doubleValue / 12)
                var months = (scenarioArray![index].nnewTotalScenarioMonths.doubleValue % 12)
                var description = "and \(months) months"
                if months == 0 {
                    description = ""
                }
                
                var s: NSString = "\(scenarioArray![index].name): repayment in \(Int(years)) years \(description)"
                let fieldFont = UIFont(name: "Helvetica Neue", size: 14)
                s.drawWithBasePoint(CGPointMake(startX+lineWidth, bounds.height-20), angle: CGFloat(-M_PI_2), font: fieldFont!)
                
            }
            
        }
    }

}
