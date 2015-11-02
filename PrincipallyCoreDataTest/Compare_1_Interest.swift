//
//  Compare_1_Interest.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 11/1/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class Compare_1_Interest: UIView {

    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        UIColor.redColor().setFill()
        path.fill()    }
    

}
