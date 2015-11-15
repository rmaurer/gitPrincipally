//
//  SelectLoanTypeView.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/26/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class firstUseOfTableViewReminder:UIView{
    var dashedBorder = CAShapeLayer()
    let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    override func drawRect(rect: CGRect) {
        let width = CGFloat(rect.width)
        let height = CGFloat(rect.height)
        var padding : CGFloat = 20
        var widthMinusPadding = width - padding
        var heightMinuspadding = height - padding
        
        var path = UIBezierPath()
        path.moveToPoint(CGPointMake(padding,padding))
        path.addLineToPoint(CGPointMake(widthMinusPadding,padding))
        path.addLineToPoint(CGPointMake(widthMinusPadding,heightMinuspadding))
        path.addLineToPoint(CGPointMake(padding,heightMinuspadding))
        path.addLineToPoint(CGPointMake(padding,padding))
        
        dashedBorder.path = path.CGPath
        dashedBorder.fillColor = clearColor.CGColor
        dashedBorder.fillRule = kCAFillRuleNonZero
        dashedBorder.lineWidth = 8.0
        dashedBorder.strokeColor = UIColor.lightGrayColor().CGColor
        dashedBorder.lineDashPattern = [20,20]
        
        self.layer.addSublayer(dashedBorder)
    }
}

class SelectLoanTypeView: UIView {

    var dashedBorder = CAShapeLayer()
    let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    //let interestLineColor = UIColor(red: 217/255.0, green: 56/255.0, blue: 41/255.0, alpha: 1)
    //var greenPrincipallyColor = UIColor(red: 249/255.0, green: 154/255.0, blue: 0/255.0, alpha: 1)
    var yellowLine = CAShapeLayer()
    @IBInspectable var principalLineColor = UIColor(red: 249/255.0, green: 154/255.0, blue: 0/255.0, alpha: 1)
    @IBInspectable var interestLineColor = UIColor(red: 217/255.0, green: 56/255.0, blue: 41/255.0, alpha: 1)
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func drawRect(rect: CGRect) {
        let width = CGFloat(rect.width)
        let height = CGFloat(rect.height)
        var padding : CGFloat = 6
        var widthMinusPadding = width - padding
        var heightMinuspadding = height - padding
        
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
        
        let halfheight = height / 2
        padding = 0
        widthMinusPadding = width - padding
        heightMinuspadding = height - padding
        let halfHeightMinusPadding : CGFloat = halfheight - padding + 3
        
        var ppath = UIBezierPath()
        ppath.moveToPoint(CGPointMake(padding,halfHeightMinusPadding))
        ppath.addLineToPoint(CGPointMake(padding,padding))
        ppath.addLineToPoint(CGPointMake(widthMinusPadding,padding))
        ppath.addLineToPoint(CGPointMake(widthMinusPadding,halfHeightMinusPadding))
        
        
        //path.addLineToPoint(CGPointMake(padding,padding))
        
        yellowLine.path = ppath.CGPath
        yellowLine.fillColor = clearColor.CGColor
        yellowLine.fillRule = kCAFillRuleNonZero
        yellowLine.lineWidth = 4.0
        yellowLine.strokeColor = interestLineColor.CGColor
        //dashedBorder.lineDashPattern = [2,2]
        
        self.layer.addSublayer(yellowLine)
        // Drawing code
    }
    

}
