//
//  FlatLabel.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/11/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class FlatLabel: UILabel {
        
       /* var gradientColors: NSArray = NSArray()
        
        init(frame: CGRect) {
            super.init(frame: frame)
        }
    
        override func drawRect(rect: CGRect)
        {
            var context: CGContextRef = UIGraphicsGetCurrentContext()
            
            let colors: NSMutableArray = NSMutableArray()
            
            self.gradientColors.enumerateObjectsUsingBlock({ object, index, stop in
                if object.isKindOfClass(UIColor) {
                    colors.addObject(object.CGColor)
                } else if CFGetTypeID(object) == CGColorGetTypeID() {
                    colors.addObject(object)
                } else {
                    NSException(name: "CRGradientLabelError", reason: "Object in gradientColors array is not a UIColor or CGColorRef", userInfo: nil).raise()
                }
            })
            
            CGContextSaveGState(context)
            CGContextScaleCTM(context, 1.0, -1.0)
            CGContextTranslateCTM(context, 0, -rect.size.height)
            
            var gradient: CGGradientRef = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), colors, nil)
            var startPoint: CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect))
            var endPoint: CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))
            
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions(kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation))
            
            CGContextRestoreGState(context)
            
            super.drawRect(rect)
            
        } */
        
    }
    

