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
    
    @IBOutlet weak var containerWidth: NSLayoutConstraint!

    @IBOutlet weak var scenarioParentView: UIView!
        
    var myContainerView = NewScenarioContainerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planPickerOutlet.dataSource = self
        planPickerOutlet.delegate = self
        viewSliderOutlet.maximumValue = Float(self.view.frame.width) - 32//Float(defaultScenarioView.frame.width)
        defaultScenarioView.graphedScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
         var totalGraphPoints : [Double] = defaultScenarioView.graphedScenario!.makeArrayOfTotalPayments()
        //you need to set these for both Default & new!
        defaultScenarioView.maxHeight = Double(maxElement(totalGraphPoints))
        defaultScenarioView.maxWidth = totalGraphPoints.count
        
        containerWidth.constant = 0
        myContainerView = self.childViewControllers[1] as! NewScenarioContainerViewController
        myContainerView.width = self.view.frame.width - 32

    }
    
    func updateScenarios() {
        //pull up the scenarios
        //defaultScenarioView is just self.defaultScenarioView
        myContainerView = self.childViewControllers[1] as! NewScenarioContainerViewController
        let updatedScenarioView = myContainerView.newScenario
        
        //pull up extra information
        let myExtraPaymentView = self.childViewControllers[0] as! RepaymentExtraTableViewController
        
        //extra Amount
        let extraAmountText = myExtraPaymentView.extraAmountOutlet.text.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        
        if let extraAmountnumber = NSNumberFormatter().numberFromString(extraAmountText){
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your extra payment amount is a number"
            alert.addButtonWithTitle("Understood")
            alert.show()
            let extraAmountnumber = 0
        }
        //extra amount frequency 
        let monthsWithExtraPaymentTotal = frequencySliderValueToMonthNumber(Int(floor(myExtraPaymentView.frequencySliderOutlet.value)))
        
        //get Picker Value
        let plan = pickerData[planPickerOutlet.selectedRowInComponent(0)]
        
        switch plan {
        case "Default":
            var test = "test"
        case "Standard Flat":
            var test = "test"
        case "Standard Graduated":
            var test = "test"
        case "Extended Flat":
            var unsavedScenario = CoreDataStack.getUnsaved(CoreDataStack.sharedInstance)()
            //start with this one as a test.  We are going to take the unsavedScenario, and wind it up with the extra payment information.  Then we want to return the max(defaultscenarioMP.count, unsavedscenarioMP.count) for the maxWidth.  We return max(allPaymentsBothDefaultAndUnsaved) for maxHeight.  Then we set maxWidth and MaxHeight for both of the views
            
            var test = "test"
        case "Extended Graduated":
            var test = "test"
        case "Income Based Repayment (IBR)":
            var test = "test"
        case "Pay As You Earn (PAYE)":
            var test = "test"
        case "Private Refinance":
            var test = "test"
        default: break
        }
        
    }
    
    func frequencySliderValueToMonthNumber(ssender:Int) -> Int {
        switch ssender {
        case 0:
            return 0
        case 1,2,3,4,5,6,7,8,9,10,11:
            return ssender
        case 12:
            return 12
        case 13:
            return 18
        case 14:
            return 24
        case 15:
            return 30
        case 16:
            return 36
        case 17:
            return 48
        case 18:
            return 60
        case 19:
            return 999
        default:
            return 0
    }
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
    
    
    @IBOutlet weak var viewSliderOutlet: UISlider!
    
    
    @IBAction func viewSlider(sender: UISlider) {
        
        sender.value = floor(sender.value)
        
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
            var constant = sender.value
            self.containerWidth.constant = CGFloat(constant)
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
