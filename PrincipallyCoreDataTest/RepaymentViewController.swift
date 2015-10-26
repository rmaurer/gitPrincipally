//
//  RepaymentViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/1/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class RepaymentViewController: UIViewController {}
/*UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, ChildViewControllerDelegate {

    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    
    var emptyMonthlyPayment : MonthlyPayment!
    
    @IBOutlet weak var planPickerOutlet: UIPickerView!
    
    @IBOutlet weak var containerWidth: NSLayoutConstraint!

    @IBOutlet weak var scenarioParentView: UIView!
        
    @IBOutlet weak var sliderWidth: NSLayoutConstraint!
    
    var myContainerView = NewScenarioContainerViewController()
    
    var MP_DefaultScenario = NSMutableOrderedSet()
    var MP_NewScenario = NSMutableOrderedSet()
    
    //Labels
    
    @IBOutlet weak var newPrincipal: UILabel!
    
    @IBOutlet weak var newInterest: UILabel!
    
    @IBOutlet weak var newTotal: UILabel!
    
    @IBOutlet weak var defaultPrincipal: UILabel!
    
    @IBOutlet weak var defaultInterest: UILabel!
    
    @IBOutlet weak var defaultTotal: UILabel!
    
    @IBOutlet weak var principalTextLabel: UILabel!
    
    @IBOutlet weak var interestTextLabel: UILabel!
    
    @IBOutlet weak var totalTextLabel: UILabel!
    
    var defaultMaxWidthMaxHeight = [Double]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        
        emptyMonthlyPayment = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        emptyMonthlyPayment.interest = 0//balance * rate
        emptyMonthlyPayment.principal = 0//monthlyPayment - (balance * rate)
        emptyMonthlyPayment.totalPayment = 0//monthlyPayment
        
        planPickerOutlet.dataSource = self
        planPickerOutlet.delegate = self
        defaultScenarioView.graphedScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
         var totalGraphPoints : [Double] = defaultScenarioView.graphedScenario!.makeArrayOfTotalPayments()
        
        
        //you need to set these for both Default & new!
        defaultScenarioView.maxHeight = Double(maxElement(totalGraphPoints))
        defaultScenarioView.maxWidth = totalGraphPoints.count
        defaultMaxWidthMaxHeight.append(Double(defaultScenarioView.maxWidth))
        defaultMaxWidthMaxHeight.append(defaultScenarioView.maxHeight)
        
        containerWidth.constant = 0
        myContainerView = self.childViewControllers[1] as! NewScenarioContainerViewController
        myContainerView.width = self.view.frame.width - 32
        
        //set the MPs for the initial load, which is just the default Scenario
        MP_DefaultScenario = defaultScenarioView.graphedScenario!.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        
        MP_NewScenario = defaultScenarioView.graphedScenario!.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        
        sliderWidth.constant = myContainerView.width
        
        viewSliderOutlet.maximumValue = Float(MP_DefaultScenario.count - 1) //Float(self.view.frame.width) - 32//Float(defaultScenarioView.frame.width)

        
    }
    
    func updateScenarios(childViewController:RepaymentExtraTableViewController) {
        //pull up the scenarios
        //defaultScenarioView is just self.defaultScenarioView
        println("updateScenarios was called")
        
        myContainerView = self.childViewControllers[1] as! NewScenarioContainerViewController
        let updatedScenarioView = myContainerView.newScenario
        
        //pull up extra information
        let myExtraPaymentView = self.childViewControllers[0] as! RepaymentExtraTableViewController
        
        //extra Amount
        let extraAmountText = myExtraPaymentView.extraAmountOutlet.text.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        var extraAmountNumber = NSNumber()
        if extraAmountText == ""{
            extraAmountNumber = 0}
            //you clearly don't understand how if let works
        else if let test = NSNumberFormatter().numberFromString(extraAmountText){
            extraAmountNumber = NSNumberFormatter().numberFromString(extraAmountText)!
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your extra payment amount is a number"
            alert.addButtonWithTitle("Understood")
            alert.show()
            let extraAmountNumber = 0
        }
        println("here is the extraAmountNumber: \(extraAmountNumber)")
        //extra amount frequency 
        let monthsWithExtraPaymentTotal = frequencySliderValueToMonthNumber(Int(floor(myExtraPaymentView.frequencySliderOutlet.value)))
        
        //get Picker Value
        let plan = pickerData[planPickerOutlet.selectedRowInComponent(0)]
        
        //define your array that will be returned in the switch
        var maxWidthAndHeightArray = [Double]()
        
        //pull up the unsavedScenario
        var unsavedScenario = CoreDataStack.getUnsaved(CoreDataStack.sharedInstance)()
        
        
        switch plan {
        case "Default":
            maxWidthAndHeightArray = unsavedScenario.makeNewExtraPaymentScenario(managedObjectContext, extra:extraAmountNumber.doubleValue, MWEPTotal: monthsWithExtraPaymentTotal)
        case "Standard Flat":
            maxWidthAndHeightArray = defaultMaxWidthMaxHeight
        case "Standard Graduated":
            maxWidthAndHeightArray = defaultMaxWidthMaxHeight
        case "Extended Flat":
            //start with this one as a test.  We are going to take the unsavedScenario, and wind it up with the extra payment information.  Then we want to return the max(defaultscenarioMP.count, unsavedscenarioMP.count) for the maxWidth.  We return max(allPaymentsBothDefaultAndUnsaved) for maxHeight.
            //START HERE -- this is not working right.  this should make the graphs rescale.  why not?
            maxWidthAndHeightArray = [defaultMaxWidthMaxHeight[0] + 12, defaultMaxWidthMaxHeight[1]]//unsavedScenario.extendedFlatWindUpWithExtraPayments(extraAmountNumber, MWEPT: monthsWithExtraPaymentTotal)
            
        case "Extended Graduated":
            maxWidthAndHeightArray = defaultMaxWidthMaxHeight
        case "Income Based Repayment (IBR)":
            maxWidthAndHeightArray = defaultMaxWidthMaxHeight
        case "Pay As You Earn (PAYE)":
            maxWidthAndHeightArray = defaultMaxWidthMaxHeight
        case "Private Refinance":
            maxWidthAndHeightArray = defaultMaxWidthMaxHeight
        default:
            maxWidthAndHeightArray = defaultMaxWidthMaxHeight//TODO: set this to the default
        }
        
        
        println("here is the new maxheight! \(maxWidthAndHeightArray[1])")
        //set the GraphedScenario for the new ScenarioViewupdate maxW and maxH for the Scenarios and setNeeds Display
        updatedScenarioView.graphedScenario = unsavedScenario
        updatedScenarioView.maxWidth = Int(maxWidthAndHeightArray[0])
        updatedScenarioView.maxHeight = maxWidthAndHeightArray[1]
        updatedScenarioView.setNeedsDisplay()
        self.defaultScenarioView.maxWidth = Int(maxWidthAndHeightArray[0])
        self.defaultScenarioView.maxHeight = maxWidthAndHeightArray[1]
        self.defaultScenarioView.setNeedsDisplay()
        
        //update the MPs so that the slider will work
        MP_DefaultScenario = defaultScenarioView.graphedScenario!.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        
        MP_NewScenario = updatedScenarioView.graphedScenario!.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        
        //update the slider 
        viewSliderOutlet.maximumValue = Float(maxWidthAndHeightArray[0] - 1)
    }
    
    
    
    func frequencySliderValueToMonthNumber(ssender:Int) -> Int {
        switch ssender {
            //matching these up with with the months value seen in //RepaymentExtraTableViewController
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
        let maxContainerWidth = Float(self.view.frame.width) - 32
        
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
            var constant = (sender.value / sender.maximumValue) * maxContainerWidth
            self.containerWidth.constant = CGFloat(constant)
            }, completion: nil)
        
        
        if sender.value == viewSliderOutlet.maximumValue {
            newPrincipal.hidden = true
            newTotal.hidden = true
            defaultPrincipal.hidden = true
            defaultTotal.hidden = true
            principalTextLabel.hidden = true
            totalTextLabel.hidden = true
            newPrincipal.hidden = true
            
            //defaultScenarioView is just self.defaultScenarioView
            println("updateScenarios was called")
            
            myContainerView = self.childViewControllers[1] as! NewScenarioContainerViewController
            let updatedScenarioView = myContainerView.newScenario
            newInterest.text = updatedScenarioView.graphedScenario!.defaultTotalScenarioInterest.stringValue
            defaultInterest.text = self.defaultScenarioView.graphedScenario!.defaultTotalScenarioInterest.stringValue
            interestTextLabel.text = "Total Interest"
        }
        
        else{
            newPrincipal.hidden = false
            newTotal.hidden = false
            defaultPrincipal.hidden = false
            defaultTotal.hidden = false
            principalTextLabel.hidden = false
            totalTextLabel.hidden = false
            newPrincipal.hidden = false
            
        //for each of these we either pull up the correct month, or return a monthly payment that is 0/0/0 because there's no payment there.
        var currentDefaultPayment = {(value : Float) -> MonthlyPayment in
            if Int(value) < self.MP_DefaultScenario.count - 1 {
                return self.MP_DefaultScenario[Int(value)] as! MonthlyPayment
            }
            else {
                return self.emptyMonthlyPayment
            }
        }
        
        var currentNewPayment = {(value : Float) -> MonthlyPayment in
            if Int(value) < self.MP_NewScenario.count - 1 {
                return self.MP_NewScenario[Int(value)] as! MonthlyPayment
            }
            else {
                return self.emptyMonthlyPayment
            }
        }

        var mp_DefaultInterest = round(currentDefaultPayment(sender.value).interest.floatValue * 100) / 100
        let mp_DefaultPrincipal = round(currentDefaultPayment(sender.value).principal.floatValue * 100) / 100
        let mp_DefaultTotal = round(currentDefaultPayment(sender.value).totalPayment.floatValue * 100) / 100
        
        let mp_NewInterest = round(currentNewPayment(sender.value).interest.floatValue * 100) / 100
        let mp_NewPrincipal = round(currentNewPayment(sender.value).principal.floatValue * 100) / 100
        let mp_NewTotal = round(currentNewPayment(sender.value).totalPayment.floatValue * 100) / 100

        defaultPrincipal.text = "$\(mp_DefaultPrincipal)"
        defaultInterest.text = "$\(mp_DefaultInterest)"
        defaultTotal.text = "$\(mp_DefaultTotal)"
        
        newPrincipal.text = "$\(mp_NewPrincipal)"
        newInterest.text = "$\(mp_NewInterest)"
        newTotal.text = "$\(mp_NewTotal)"
        }
    }
    //embeddedTableSegue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embeddedTableSegue" {
            let childViewController = segue.destinationViewController as! RepaymentExtraTableViewController
            childViewController.delegate = self
        }
    }


} */
