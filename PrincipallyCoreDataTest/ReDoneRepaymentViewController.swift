//
//  ReDoneRepaymentViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

protocol PlanViewDelegate{
    func chooseTypeDidFinish(type:String)
}

class ReDoneRepaymentViewController: UIViewController, PlanViewDelegate {
    
    @IBOutlet weak var planNameOutlet: UITextField!
    @IBAction func planNameAction(sender: UITextField) {
    }
    var greenPrincipallyColor = UIColor(red: 30/255, green: 149/255, blue: 127/255, alpha: 1)
    
    var scenarioWasEnteredGraphIsShowing : Bool = false
    
    let typeXIBVC = PlanTypeViewController(nibName: "PlanTypeViewController", bundle: nil)
    
    var planOptionsView = PlanOptionsTableViewController()
    var graphedScenarioView = GraphedScenarioViewController()

    var selectedScenario: Scenario?

    @IBOutlet weak var whiteBackgroundView: UIView!
    
    @IBOutlet weak var parentFlipView: UIView!
    
    @IBOutlet weak var tableContainer: UIView!
    
    @IBOutlet weak var graphedScenarioContainer: UIView!
   
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var selectLoanUIView: SelectLoanTypeView!
    
    @IBOutlet weak var selectPlanTypeButtonOutlet: UIButton!
    
    @IBAction func doneButtonAction(sender: UIBarButtonItem) {
        //Here's where we do the flipping
        loadChildViews()
        if scenarioWasEnteredGraphIsShowing {
            graphedScenarioView.scenario_UserWantsToEditAgain()
            UIView.transitionFromView(graphedScenarioContainer,
                toView: tableContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "View Repayment"
            scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing

        }
            //here is where the scenario is entered.
        else{
            graphedScenarioView.name = planNameOutlet.text
            graphedScenarioView.repaymentType =
                self.selectPlanTypeButtonOutlet.currentTitle!
            
            //here's where we load up GraphedScenarioView with all of the information
            graphedScenarioView.frequencyOfExtraPayments = frequencySliderValueToMonthNumber(planOptionsView.extraPaymentSliderOutlet.value)
            graphedScenarioView.amountOfExtraPayments = getNSNumberFromExtraPaymentString(planOptionsView.extraAmountTextField.text).doubleValue
            graphedScenarioView.interestRateOnRefi = getNSNumberFromInterestRateString(planOptionsView.interestRateOnRefinanceTextFieldOutlet.text).doubleValue
            graphedScenarioView.variableInterestRate = planOptionsView.variableInterestRateSwitchOutlet.on
            graphedScenarioView.changeInInterestRate = interestRateSliderToLIBORNumber(planOptionsView.changeInRateSliderOutlet.value)
            graphedScenarioView.AGI = getNSNumberFromAGIString(planOptionsView.adjustedGrossIncomeTextField6.text).doubleValue
           graphedScenarioView.annualSalaryIncrease = getNSNumberFromAnnualSalaryIncreaseString(planOptionsView.annualSalaryIncreaseTextField7.text).doubleValue
            graphedScenarioView.familySize = getNSNumberFromFamilySizeString(planOptionsView.familySizeTextField8.text).integerValue
            graphedScenarioView.qualifyingJob = planOptionsView.qualifyingJobSwitch.on
            graphedScenarioView.IBRDateOptions = planOptionsView.IBRDatesSwitch10.on
            graphedScenarioView.ICRReqs = planOptionsView.ICRDatesSwitch10.on
            graphedScenarioView.PAYEReqs = planOptionsView.PAYEDatesSwtich12.on
            
            
            graphedScenarioView.scenario_WindUpForGraph()
            graphedScenarioView.scenario_makeGraphVisibleWithWoundUpScenario()
            UIView.transitionFromView(tableContainer,
                toView: graphedScenarioContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "Edit"
            scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing
        }
        
    }
    
    func flipAroundGraphWithoutLoadingScenario(){
        loadChildViews()
        graphedScenarioView.currentScenario = selectedScenario
        graphedScenarioView.scenario_makeGraphVisibleWithWoundUpScenario()
        
        
        UIView.transitionFromView(tableContainer,
            toView: graphedScenarioContainer,
            duration: 1.0,
            options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
        doneButtonOutlet.title = "Edit"
        scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing
    }
    
    @IBAction func selectPlanButtonAction(sender: UIButton) {
        typeXIBVC.delegate = self
        typeXIBVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(typeXIBVC, animated: true, completion: nil)
    
    }

    func chooseTypeDidFinish(type:String){
        self.selectPlanTypeButtonOutlet.setTitle(type, forState: .Normal)
        self.selectPlanTypeButtonOutlet.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.selectLoanUIView.dashedBorder.lineDashPattern = [1,0]
        self.selectLoanUIView.dashedBorder.setNeedsDisplay()
        let table = self.childViewControllers[1] as! PlanOptionsTableViewController
        table.selectedRepaymentPlan = type
        table.tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        whiteBackgroundView.layer.borderWidth = 4
        whiteBackgroundView.layer.borderColor = greenPrincipallyColor.CGColor
        if selectedScenario != nil {
            flipAroundGraphWithoutLoadingScenario()
        }
        //selectPlanTypeButtonOutlet.layer.backgroundColor = greenPrincipallyColor.CGColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadChildViews(){
        planOptionsView = self.childViewControllers[1] as! PlanOptionsTableViewController
        graphedScenarioView = self.childViewControllers[0] as! GraphedScenarioViewController
    }
    
    func frequencySliderValueToMonthNumber(ssender:Float) -> Int {
        switch floor(ssender) {
            //matching these up with with the months value seen in //RepaymentExtraTableViewController
        case 0:
            return 0
        case 1,2,3,4,5,6,7,8,9,10,11:
            return Int(floor(ssender))
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
    
    func interestRateSliderToLIBORNumber(ssender:Float) -> Double {
        switch floor(ssender){
        case 0: return 0.19
        case 1: return 0.4
        case 2: return 2
        case 3: return 5
        case 4: return 11
        default: return 0.19
        }
    }

    func getNSNumberFromExtraPaymentString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your extra payment amount is entered correct"
            alert.addButtonWithTitle("Understood")
            alert.show()
            return -1
        }
    }
    
    func getNSNumberFromInterestRateString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your interest rate is entered correctly"
            alert.addButtonWithTitle("Understood")
            alert.show()
            return -1
        }
    }

    
    func getNSNumberFromAGIString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your adjusted gross income is entered correctly"
            alert.addButtonWithTitle("Understood")
            alert.show()
            return -1
        }
    }
    
    func getNSNumberFromFamilySizeString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your family size is entered correctly"
            alert.addButtonWithTitle("Understood")
            alert.show()
            return -1
        }
    }
    
    func getNSNumberFromAnnualSalaryIncreaseString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your annual salary increase is entered correctly"
            alert.addButtonWithTitle("Understood")
            alert.show()
            return -1
        }
    }

/*
    //Select Loan Type
    let loanVC = TypeModalVC(nibName: "TypeModalVC", bundle: nil)
    
    @IBOutlet weak var selectLoanUIView: SelectLoanTypeView!
    
    @IBOutlet weak var selectLoantype: UIButton!
    
    @IBAction func selectLoanTypeAction(sender: UIButton) {
    loanVC.delegate = self
    loanVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
    presentViewController(loanVC, animated: true, completion: nil)
    
    }
    

    
    
    */

}
