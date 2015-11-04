//
//  ContentViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/31/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class ContentViewController: UIViewController {

    @IBOutlet weak var testCompare1: Compare_1_Interest!
    
    var scenarioArray:[Scenario]!
    
    //yourLabelName.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
    
    @IBOutlet weak var compareLabel: UILabel!
    
    @IBOutlet weak var compareUIView: UIView!
    
    var backgroundColor : UIColor = UIColor.lightGrayColor()
    
    var compareLabelText : String = ""
    
    var pageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compareUIView.backgroundColor = backgroundColor
        compareLabel.text = compareLabelText
        testCompare1.setNeedsDisplay()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        for vview in compareUIView.subviews {
            if let vview = vview as? Compare_1_Interest {
                let frame = CGRectMake(0,0,compareUIView.frame.width,compareUIView.frame.height)
                vview.frame = frame
                vview.setNeedsDisplay()
            }
            else if let vview = vview as? Compare_2_Principal {
                let frame = CGRectMake(0,0,compareUIView.frame.width,compareUIView.frame.height)
                vview.frame = frame
                vview.setNeedsDisplay()
            }
            else if let vview = vview as? Compare_3_InitialPayment{
                let frame = CGRectMake(0,0,compareUIView.frame.width,compareUIView.frame.height)
                vview.frame = frame
                vview.setNeedsDisplay()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func add1(){
        var v = self.view
        for view in compareUIView.subviews {
            if view is Compare_1_Interest || view is Compare_2_Principal || view is Compare_3_InitialPayment {
                view.removeFromSuperview()
            }
        }

        var interestView = Compare_1_Interest(frame: self.compareUIView.frame)
        compareUIView.addSubview(interestView)
    }
    
    func add2(){
        var v = self.view
        for view in compareUIView.subviews {
            if view is Compare_1_Interest || view is Compare_2_Principal || view is Compare_3_InitialPayment {
                view.removeFromSuperview()
            }
        }
        let width = self.view.frame.width - 20
        
        var interestView = Compare_2_Principal(frame: self.compareUIView.frame)
        compareUIView.addSubview(interestView)
    }
    
    //Starthere:UGHHHHHH get this subview to match the frame
    
    func add3(){
        var v = self.view
        for view in compareUIView.subviews {
            if view is Compare_1_Interest || view is Compare_2_Principal || view is Compare_3_InitialPayment {
                view.removeFromSuperview()
            }
        }
        var interestView = Compare_3_InitialPayment(frame: self.compareUIView.frame)
        compareUIView.addSubview(interestView)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}