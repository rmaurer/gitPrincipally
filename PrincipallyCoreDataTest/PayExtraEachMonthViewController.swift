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


//toDelete: this view controller is no longer in use. 
class PayExtraEachMonthViewController: UIViewController {
 /*
    var oArray = NSOrderedSet()
    var test = NSNumber()
    var sliderExtraNum : Int = 0
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    var unsavedScenario: Scenario!
    var defaultScenario: Scenario!
    var newInterest : Double = 0
    var newInterestLayer = CALayer()
    var app = principallyApp()
    var mpForDefaultScenario = NSMutableOrderedSet()
    var mpForUnsavedScenario = NSMutableOrderedSet()
    
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
        
    }
    
    @IBOutlet weak var graphOfExtraPaymentScenario: GraphOfScenario!
    
    @IBOutlet weak var extraAmount: UITextField!
    
    @IBAction func graphSlider(sender: UISlider) {
        sender.value = floor(sender.value)
        let totalMonths = defaultScenario!.defaultTotalScenarioMonths.floatValue
        //graphOfExtraPaymentScenario.CAWhiteLine.timeOffset = CFTimeInterval(sender.value / totalMonths)
        
        var defaultPayment = mpForDefaultScenario[Int(sender.value)] as! MonthlyPayment
        
        var unsavedScenarioPayment = mpForUnsavedScenario[Int(sender.value)] as! MonthlyPayment
        
        principalNewLabel.text = "$\(unsavedScenarioPayment.principal)"
        principalDefaultLabel.text = "Compared to $\(defaultPayment.principal)"
        
        interestNewLabel.text = "$\(unsavedScenarioPayment.interest)"
        interestDefaultLabel.text = "Compared to $\(defaultPayment.interest)"
        
        var difference = unsavedScenario.defaultTotalScenarioInterest.doubleValue - unsavedScenario.nnewTotalScenarioInterest.doubleValue
        
        totalAmountSavedLabel.text = "\(sender.value)"//"\(difference)"
        println(defaultScenario.defaultTotalScenarioMonths.floatValue)
        
        //var monthAndYear = clickedLoan!.getStringOfYearAndMonthForPaymentNumber(Double(sender.value))
        //paymentDescription.text = "This is payment number #\(sender.value) to be paid in \(monthAndYear), which consist of principal $\(thisLoan.principal) and $\(thisLoan.interest) in interest, for a total of $\(thisLoan.totalPayment)"
        //println(sender.value)
        
    }
    
    @IBOutlet weak var graphSliderOutlet: UISlider!
    
    @IBOutlet weak var principalNewLabel: UILabel!
    
    @IBOutlet weak var principalDefaultLabel: UILabel!
    
    @IBOutlet weak var interestNewLabel: UILabel!
    
    @IBOutlet weak var totalAmountSavedLabel: UILabel!
    
    @IBOutlet weak var interestDefaultLabel: UILabel!
    
    @IBAction func extraAmountEditingChanged(sender: UITextField) {
        if let extra = sender.text.toInt() {
            //get the monthNumber
            let monthNumber = convertSliderNumberToMonthsWithExtraPayment(Int(frequencySliderOutlet.value))
            
            unsavedScenario.makeNewExtraPaymentScenario(managedObjectContext,extra:Double(extra),MWEPTotal:monthNumber)
            
            var error: NSError?
            if !managedObjectContext.save(&error) {
                println("Could not save: \(error)") }
            println("after function call")
            app.printAllScenariosAndLoans()
            mpForUnsavedScenario = unsavedScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
            let maxInterest = maxElement(defaultScenario.makeArrayOfAllInterestPayments())
            newInterestLayer.sublayers = nil
            newInterestLayer = unsavedScenario.makeCALayerWithInterestLine(graphOfExtraPaymentScenario.frame, color: UIColor.purpleColor().CGColor, maxValue: maxInterest)
            graphOfExtraPaymentScenario.layer.addSublayer(newInterestLayer)
            graphOfExtraPaymentScenario.setNeedsDisplay()
        }else{
            println("it's a string")
            //graphOfExtraPaymentScenario.CAWhiteLine.timeOffset = 0.5
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
        unsavedScenario = CoreDataStack.getUnsaved(CoreDataStack.sharedInstance)()
        defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        graphOfExtraPaymentScenario.graphedScenario = defaultScenario
        //graphOfExtraPaymentScenario.unsavedScenario = unsavedScenario
        var error: NSError?
        graphSliderOutlet.maximumValue = Float(defaultScenario.concatenatedPayment.count) - 1
        graphSliderOutlet.setValue(0, animated: true)
        oArray = defaultScenario.allLoans
        
        unsavedScenario.defaultScenarioMaxPayment = defaultScenario.defaultScenarioMaxPayment
        unsavedScenario.defaultTotalScenarioInterest = defaultScenario.defaultTotalScenarioInterest
        unsavedScenario.defaultTotalScenarioMonths = defaultScenario.defaultTotalScenarioMonths
        
        mpForDefaultScenario = defaultScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        mpForUnsavedScenario = unsavedScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        
        //check to make sure some loans have been entered
        if oArray.count == 0 {
            var myLoans = [NSManagedObject]()
            var error: NSError?
            let fetchRequest = NSFetchRequest(entityName:"Loan")
            let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
            if let results = fetchedResults {
                myLoans = results}
            for loan in myLoans {
                var loan = loan as! Loan
                println(loan.name)
                println(loan.thisLoansScenario.name)
            }
            if myLoans.count == 0 {
                println("there are actually no loans.")
            }
            
            
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
        app.printAllScenariosAndLoans()
        


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
 */
}
