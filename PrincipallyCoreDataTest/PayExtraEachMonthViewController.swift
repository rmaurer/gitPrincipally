//
//  PayExtraEachMonthViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PayExtraEachMonthViewController: UIViewController {

    var oArray = NSMutableArray()
    var sliderExtraNum : Int = 0
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    var unsavedScenario: Scenario!
    var defaultScenario: Scenario!
    var newInterest : Double = 0
    var newInterestLayer = CALayer()
    
    func convertSliderNumberToMonthsWithExtraPayment(senderValue:Int) -> Int {
        switch senderValue{
        case 1,2,3,4,5,6,7,8,9,10,11,12:
        return Int(senderValue)
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
        return 999
        }
    }
    
    @IBAction func testButton(sender: UIButton) {
        //graphOfExtraPaymentScenario.CAWhiteLine.backgroundColor = UIColor.purpleColor().CGColor
        let maxInterest = maxElement(defaultScenario.makeArrayOfAllInterestPayments())
        newInterestLayer.sublayers = nil
        newInterestLayer = unsavedScenario.makeCALayerWithInterestLine(graphOfExtraPaymentScenario.frame, color: UIColor.purpleColor().CGColor, maxValue: maxInterest)
        graphOfExtraPaymentScenario.layer.addSublayer(newInterestLayer)
        graphOfExtraPaymentScenario.setNeedsDisplay()
        
        
    }
    
    @IBOutlet weak var graphOfExtraPaymentScenario: GraphOfScenario!
    
    @IBOutlet weak var extraAmount: UITextField!
    
    @IBAction func extraAmountEditingChanged(sender: UITextField) {
        if let extra = sender.text.toInt() {
            //get the monthNumber
            let monthNumber = convertSliderNumberToMonthsWithExtraPayment(Int(frequencySliderOutlet.value))
            
            //
            unsavedScenario.makeNewExtraPaymentScenario(managedObjectContext, oArray: oArray,extra:extra,monthsThatNeedExtraPayment:monthNumber)
            
        }else{
            println("it's a string")
            graphOfExtraPaymentScenario.CAWhiteLine.timeOffset = 0.5
            //it's a string, and we don't do any calculations
        }
    }
    @IBOutlet weak var frequencySliderOutlet: UISlider!
    
    @IBAction func frequencySlider(sender: UISlider) {
        sender.value = Float(Int(sender.value))
        switch sender.value {
        case 1:
            return frequencyLabel.text = "1 month"
        case 2,3,4,5,6,7,8,9,10,11:
            return frequencyLabel.text = "\(Int(sender.value)) months"
        case 12:
            return frequencyLabel.text = "12 months"
        case 13:
            return frequencyLabel.text = "18 months"
        case 14:
            return frequencyLabel.text = "24 months"
        case 15:
            return frequencyLabel.text = "30 months"
        case 16:
            return frequencyLabel.text = "3 years"
        case 17:
            return frequencyLabel.text = "4 years"
        case 18:
            return frequencyLabel.text = "5 years"
        case 19:
            return frequencyLabel.text = "Every time"
        default:
            return frequencyLabel.text = "Every time"
        }
        
    }
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var unsavedScenario = CoreDataStack.getUnsaved(CoreDataStack.sharedInstance)()
        var defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        var error: NSError?
        oArray = defaultScenario.allLoans.copy() as! NSMutableArray
        
        //check to make sure some loans have been entered
        if oArray.count == 0 {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "You need to enter loans to explore repayment possibilities."
            alert.addButtonWithTitle("Understood")
            alert.show()
        }
        
        //saved managedObjectContext in case there was an addition of UnsavedScenario
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        //this should become deprecated -- we need to add a "total payment and max total payment" feature to the scenario
        let maxInterest = maxElement(defaultScenario.makeArrayOfAllInterestPayments())
        
        //add the loan with the default scenario
        let newLayer = defaultScenario.makeCALayerWithInterestLine(graphOfExtraPaymentScenario.frame, color: UIColor.blackColor().CGColor, maxValue: maxInterest)
        graphOfExtraPaymentScenario.layer.addSublayer(newLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
