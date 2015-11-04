//
//  Compare_2_Principal.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 11/1/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class Compare_2_Principal: UIView {

    var scenarioArray : [Scenario]? = nil
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        UIColor.orangeColor().setFill()
        path.fill()
    }
    

}
