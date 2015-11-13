//
//  ScenarioTypeView.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/14/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class ScenarioTypeView: UIView {

        
        var dashedBorder = CAShapeLayer()
        let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        var greenPrincipallyColor = UIColor(red: 249/255.0, green: 154/255.0, blue: 0/255.0, alpha: 1)
    
        // actual green principally color UIColor(red: 30/255, green: 149/255, blue: 127/255, alpha: 1)
        // Only override drawRect: if you perform custom drawing.
        // An empty implementation adversely affects performance during animation.
        
        override func drawRect(rect: CGRect) {
            let width = CGFloat(rect.width)
            let height = CGFloat(rect.height)
            let halfheight = height / 2
            let padding : CGFloat = 0
            let widthMinusPadding = width - padding
            let heightMinuspadding = height - padding
            let halfHeightMinusPadding : CGFloat = 18 //halfheight - padding
            
            var path = UIBezierPath()
            path.moveToPoint(CGPointMake(padding,halfHeightMinusPadding))
            path.addLineToPoint(CGPointMake(padding,padding))
            path.addLineToPoint(CGPointMake(widthMinusPadding,padding))
            path.addLineToPoint(CGPointMake(widthMinusPadding,halfHeightMinusPadding))
            

            //path.addLineToPoint(CGPointMake(padding,padding))
            
            dashedBorder.path = path.CGPath
            dashedBorder.fillColor = clearColor.CGColor
            dashedBorder.fillRule = kCAFillRuleNonZero
            dashedBorder.lineWidth = 4.0
            dashedBorder.strokeColor = greenPrincipallyColor.CGColor
            //dashedBorder.lineDashPattern = [2,2]
            
            self.layer.addSublayer(dashedBorder)
            // Drawing code
        }
        
        
    }

