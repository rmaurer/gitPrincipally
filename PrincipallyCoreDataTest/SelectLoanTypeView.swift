//
//  SelectLoanTypeView.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/26/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class SelectLoanTypeView: UIView {

    var dashedBorder = CAShapeLayer()
     let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let width = CGFloat(rect.width)
        let height = CGFloat(rect.height)
        let padding : CGFloat = 5
        let widthMinusPadding = width - padding
        let heightMinuspadding = height - padding
       var path = UIBezierPath()
        path.moveToPoint(CGPointMake(padding,padding))
        path.addLineToPoint(CGPointMake(widthMinusPadding,padding))
        path.addLineToPoint(CGPointMake(widthMinusPadding,heightMinuspadding))
        path.addLineToPoint(CGPointMake(padding,heightMinuspadding))
        path.addLineToPoint(CGPointMake(padding,padding))
        
        dashedBorder.path = path.CGPath
        dashedBorder.fillColor = clearColor.CGColor
        dashedBorder.fillRule = kCAFillRuleNonZero
        dashedBorder.lineWidth = 1.0
        dashedBorder.strokeColor = UIColor.grayColor().CGColor
        dashedBorder.lineDashPattern = [2,2]
        
        self.layer.addSublayer(dashedBorder)
        // Drawing code
    }
    

}
