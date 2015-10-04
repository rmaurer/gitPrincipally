//
//  RepaymentViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/1/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class RepaymentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var planPickerOutlet: UIPickerView!
    
    @IBOutlet weak var yellowGraphOfScenario: GraphOfScenario!
    

    @IBOutlet weak var scenarioParentView: UIView!
    
    @IBOutlet weak var innerYellowWidth: NSLayoutConstraint!
    
    @IBOutlet weak var sideConstraintTest: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planPickerOutlet.dataSource = self
        planPickerOutlet.delegate = self
        viewSliderOutlet.maximumValue = Float(scenarioParentView.frame.width)
        defaultScenarioView.graphedScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        yellowGraphOfScenario.graphedScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        //innerYellowWidth.constant = scenarioParentView.frame.width
        rightEdgeYellow.constant = scenarioParentView.frame.width - 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let pickerData = ["Default", "Standard Flat","Standard Graduated","Extended Flat","Extended Graduated","Income Based Repayment (IBR)","Pay As You Earn (PAYE)","Private Refinance"]
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //updateLabel()
    }

    @IBOutlet weak var defaultScenarioView: GraphOfScenario!
    
    @IBOutlet weak var yellowView: UIView!
    
    @IBOutlet weak var viewSliderOutlet: UISlider!
    
    @IBOutlet weak var rightEdgeYellow: NSLayoutConstraint!
    
    @IBAction func viewSlider(sender: UISlider) {
        
        sender.value = floor(sender.value)
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
            var yellowViewFrame = self.yellowView.frame
           // yellowViewFrame.origin.x = CGFloat(sender.value)
            self.yellowView.frame = CGRectMake(yellowViewFrame.origin.x, yellowViewFrame.origin.y, CGFloat(sender.value), yellowViewFrame.height)
            }, completion: nil)
        
        
        
    }
    
  
    
    /*
            graphOfEnteredLoan.CAWhiteLine.duration = NSTimeInterval(firstLoan.monthsInRepaymentTerm.floatValue - firstLoan.monthsUntilRepayment.floatValue)
    
    CAWhiteLine.frame = CGRectMake(22,0,2,CGFloat(rect.height))
    CAWhiteLine.backgroundColor = UIColor.whiteColor().CGColor
    
    self.layer.addSublayer(CAWhiteLine)
    
    let animation = CABasicAnimation(keyPath: "transform.translation.x")
    animation.fromValue = 0 //NSValue(CGRect: CAWhiteLine.frame)
    animation.toValue = rect.width - 6 //NSValue(CGRect: CGRectMake(140,0,4,CGFloat(rect.height)))
    animation.duration = 1.0
    
    CAWhiteLine.addAnimation(animation, forKey: "animate transform animation")
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
