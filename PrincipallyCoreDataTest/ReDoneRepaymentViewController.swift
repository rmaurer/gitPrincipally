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

class ReDoneRepaymentViewController: UIViewController, PlanViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var editingPen: UIImageView!
    
    @IBOutlet weak var planNameOutlet: UITextField!
    
    @IBAction func planNameAction(sender: UITextField) {
    }
    var greenPrincipallyColor = UIColor(red: 30/255, green: 149/255, blue: 127/255, alpha: 1)
    
    var scenarioWasEnteredGraphIsShowing : Bool = false
    
    let typeXIBVC = PlanTypeViewController(nibName: "PlanTypeViewController", bundle: nil)
    
    var planOptionsView = PlanOptionsTableViewController()
    
    var repaymentName : String = ""
    var repaymentType : String = ""
    

    
    var graphedScenarioView = GraphViewController()

    var selectedScenario: Scenario?

    @IBOutlet weak var selectedLoanTypeView: SelectLoanTypeView!
    
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
            self.selectPlanTypeButtonOutlet.setTitle(graphedScenarioView.currentScenario.settings.repaymentType, forState: .Normal)
            planOptionsView.selectedRepaymentPlan = graphedScenarioView.currentScenario.settings.repaymentType
            planOptionsView.reloadScenarioSettings(graphedScenarioView.currentScenario.settings)
            graphedScenarioView.scenario_UserWantsToEditAgain()
            
            UIView.transitionFromView(graphedScenarioContainer,
                toView: tableContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "Save Repayment"
            scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing

        }
            //here is where the scenario is entered.
        else{
            editingPen.hidden = true
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
            graphedScenarioView.familySize = Int(floor(planOptionsView.familySizeStepperOutlet.value))
            graphedScenarioView.qualifyingJob = planOptionsView.qualifyingJobSwitch.on
            graphedScenarioView.IBRDateOptions = planOptionsView.IBRDatesSwitch10.on
            graphedScenarioView.ICRReqs = planOptionsView.ICRDatesSwitch10.on
            graphedScenarioView.PAYEReqs = planOptionsView.PAYEDatesSwtich12.on
            graphedScenarioView.refiTerm = getRefiTermYears(planOptionsView.repaymentTermSlider.value)
            graphedScenarioView.yearsInProgram = Int(floor(planOptionsView.stepperOutlet.value))
            graphedScenarioView.oneTimePayoff = getNSNumberFromOneTimePayoffString(planOptionsView.oneTimePayoffTextFieldOutlet.text).doubleValue
            graphedScenarioView.headOfHousehold = planOptionsView.headOfHouseholdSwitch.on

            
            if graphedScenarioView.scenario_WindUpForGraph() &&  graphedScenarioView.amountOfExtraPayments != -1 && graphedScenarioView.interestRateOnRefi != -1 && graphedScenarioView.AGI != -1  && graphedScenarioView.annualSalaryIncrease != -1 && graphedScenarioView.oneTimePayoff != -1 {
                graphedScenarioView.scenario_makeGraphVisibleWithWoundUpScenario()
            
                UIView.transitionFromView(tableContainer,
                toView: graphedScenarioContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
                sender.title = "Edit"
                resetAllTextFields()
                scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing
            }
        }
        
    }
    @IBAction func scenarioNameEditingChanged(sender: UITextField) {
        editingPen.hidden = true
    }
    
    func flipAroundGraphWithoutLoadingScenario(){
        loadChildViews()
        graphedScenarioView.currentScenario = selectedScenario
        graphedScenarioView.scenario_makeGraphVisibleWithWoundUpScenario()
        editingPen.hidden = true

        
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
        self.loadChildViews()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        selectedLoanTypeView.interestLineColor = UIColor(red: 249/255.0, green: 154/255.0, blue: 0/255.0, alpha: 1)
        whiteBackgroundView.layer.borderWidth = 4
        whiteBackgroundView.layer.borderColor = greenPrincipallyColor.CGColor
        planNameOutlet.delegate = self
        
        
        let scenarioNum = CoreDataStack.getNumberofScenarios(CoreDataStack.sharedInstance)() + 1
        planNameOutlet.text = "Repayment Plan #\(scenarioNum)"
        
        if selectedScenario != nil {
            flipAroundGraphWithoutLoadingScenario()
            selectPlanTypeButtonOutlet.setTitle(selectedScenario!.repaymentType, forState: .Normal)
            planNameOutlet.text = selectedScenario!.name
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        let loanNum = CoreDataStack.getNumberOfLoans(CoreDataStack.sharedInstance)()
        if loanNum == 0{
            doneButtonOutlet.enabled = false
        }
        else{
            doneButtonOutlet.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        let maxLength = 20
        let currentString: NSString = textField.text
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.loadChildViews()
        planOptionsView.resignResponder()
    }
    
    
    func getRefiTermYears(ssender:Float) -> Int {
        let intSender = Int(floor(ssender))
        switch intSender {
        case 0:
            return 5
        case 1:
            return 7
        case 2:
            return 10
        case 3:
            return 15
        case 4:
            return 20
        default:
            return 10

    }
    }
    
    func loadChildViews(){
        planOptionsView = self.childViewControllers[1] as! PlanOptionsTableViewController
        graphedScenarioView = self.childViewControllers[0] as! GraphViewController
    }
    
    func frequencySliderValueToMonthNumber(ssender:Float) -> Int {
        switch floor(ssender) {
          
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
        case 0: return 0
        case 1: return 1
        case 2: return 2
        case 3: return 4
        case 4: return 6
        case 5: return 8
        default: return 0
        }
    }
    
    func resetAllTextFields(){
        planOptionsView.extraAmountTextField.layer.borderColor = UIColor.clearColor().CGColor
        planOptionsView.interestRateOnRefinanceTextFieldOutlet.layer.borderColor = UIColor.clearColor().CGColor
        planOptionsView.adjustedGrossIncomeTextField6.layer.borderColor = UIColor.clearColor().CGColor
        planOptionsView.annualSalaryIncreaseTextField7.layer.borderColor = UIColor.clearColor().CGColor
        planOptionsView.oneTimePayoffTextFieldOutlet.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func shakeTextField (textField : UITextField, numberOfShakes : Int, direction: CGFloat, maxShakes : Int) {
        
        textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 2
        
        let interval : NSTimeInterval = 0.03
        
        UIView.animateWithDuration(interval, animations: { () -> Void in
            textField.transform = CGAffineTransformMakeTranslation(5 * direction, 0)
            
            }, completion: { (aBool :Bool) -> Void in
                
                if (numberOfShakes >= maxShakes) {
                    textField.transform = CGAffineTransformIdentity
                    textField.becomeFirstResponder()
                    return
                }
                
                self.shakeTextField(textField, numberOfShakes: numberOfShakes + 1, direction: direction * -1, maxShakes: maxShakes )
                
        })
        
    }

    func getNSNumberFromExtraPaymentString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(",", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(" ", withString: "", options: .allZeros, range:nil)
        //println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            /*let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "The extra payment amount needs to be a dollar amount Please make sure your extra payment amount is entered correct"
            alert.addButtonWithTitle("Understood")
            alert.show()*/
            shakeTextField(planOptionsView.extraAmountTextField, numberOfShakes:0, direction:1, maxShakes:5)
            return -1
        }
    }
    
    func getNSNumberFromInterestRateString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(",", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(" ", withString: "", options: .allZeros, range:nil)
        //println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            /*let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your interest rate is entered correctly"
            alert.addButtonWithTitle("Understood")
            alert.show()*/
            shakeTextField(planOptionsView.interestRateOnRefinanceTextFieldOutlet, numberOfShakes:0, direction:1, maxShakes:5)
            return -1
        }
    }

    
    func getNSNumberFromAGIString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(",", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(" ", withString: "", options: .allZeros, range:nil)
        //println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            /*let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your adjusted gross income is entered correctly"
            alert.addButtonWithTitle("Understood")
            alert.show()*/
            shakeTextField(planOptionsView.adjustedGrossIncomeTextField6, numberOfShakes:0, direction:1, maxShakes:5)
            return -1
        }
    }
    
    /*func getNSNumberFromFamilySizeString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(",", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(",", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(" ", withString: "", options: .allZeros, range:nil)
        //println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            /*let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your family size is entered correctly"
            alert.addButtonWithTitle("Understood")
            alert.show()*/
            shakeTextField(planOptionsView.adjustedGrossIncomeTextField6, numberOfShakes:0, direction:1, maxShakes:5)
            return -1
        }
    }*/
    
    func getNSNumberFromAnnualSalaryIncreaseString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(",", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(" ", withString: "", options: .allZeros, range:nil)
        //println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            /*let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your annual salary increase is entered correctly"
            alert.addButtonWithTitle("Understood")
            alert.show()*/
            shakeTextField(planOptionsView.annualSalaryIncreaseTextField7, numberOfShakes:0, direction:1, maxShakes:5)
            return -1
        }
    }
    
    
    func getNSNumberFromOneTimePayoffString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(",", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString(" ", withString: "", options: .allZeros, range:nil)
        //println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            return 0
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            /*let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your one time payoff is entered correct"
            alert.addButtonWithTitle("Understood")
            alert.show()*/
            shakeTextField(planOptionsView.oneTimePayoffTextFieldOutlet, numberOfShakes:0, direction:1, maxShakes:5)
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
