//
//  PlanOptionsTableViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class PlanOptionsTableViewController: UITableViewController {

    var selectedRepaymentPlan : String?
    
    func monthNumbertoSliderValue(monthNumber:Double) -> Float {
        switch floor(monthNumber) {
            //matching these up with with the months value seen in //RepaymentExtraTableViewController
        case 0:
            return 0
        case 1,2,3,4,5,6,7,8,9,10,11:
            return Float(floor(monthNumber))
        case 12:
            return 12
        case 18:
            return 13
        case 24:
            return 14
        case 30:
            return 15
        case 36:
            return 16
        case 48:
            return 17
        case 60:
            return 18
        case 999:
            return 19
        default:
            return 0
        }
    }
    
    func extraPaymentNumberToLabeLText(sliderValue: Float) {
        switch sliderValue {
        case 0:
            return extraPaymentAmountLabel.text = "Never"
        case 1:
            return extraPaymentAmountLabel.text = "1 month"
        case 2,3,4,5,6,7,8,9,10,11:
            return extraPaymentAmountLabel.text = "\(Int(sliderValue)) months"
        case 12:
            return extraPaymentAmountLabel.text = "12 months"
        case 13:
            return extraPaymentAmountLabel.text = "18 months"
        case 14:
            return extraPaymentAmountLabel.text = "24 months"
        case 15:
            return extraPaymentAmountLabel.text = "30 months"
        case 16:
            return extraPaymentAmountLabel.text = "3 years"
        case 17:
            return extraPaymentAmountLabel.text = "4 years"
        case 18:
            return extraPaymentAmountLabel.text = "5 years"
        case 19:
            return extraPaymentAmountLabel.text = "Every time"
        default:
            return extraPaymentAmountLabel.text = "Every time"
        }
        
    }
    
    func lIBORnumbertoSliderValue(ssender:Double) -> Float {
        switch floor(ssender){
        case 0: return 0
        case 1: return 1
        case 2: return 2
        case 4: return 3
        case 6: return 4
        case 8: return 5
        default: return 0
        }
    }
    
    func getSliderValueFromRefiTermYears(ssender:Double) -> Float {
        let intSender = Int(floor(ssender))
        switch intSender {
        case 5:
            return 0
        case 7:
            return 1
        case 10:
            return 2
        case 15:
            return 3
        case 20:
            return 4
        default:
            return 1
            
        }
    }
    
    func reloadScenarioSettings(settings:ScenarioSettings){
        self.tableView.reloadData()
        extraPaymentSliderOutlet.value = self.monthNumbertoSliderValue(settings.frequencyOfExtraPayments.doubleValue)
        extraPaymentNumberToLabeLText(extraPaymentSliderOutlet.value)
        //extraPaymentAmountLabel.text =
        extraAmountTextField.text = "$\(floor(settings.amountOfExtraPayments.doubleValue * 100) / 100)"
        interestRateOnRefinanceTextFieldOutlet.text = "\(floor(settings.interestRateOnRefi.doubleValue * 1000) / 1000)%"
        variableInterestRateSwitchOutlet.setOn(settings.variableInterestRate.boolValue, animated:true)
        changeInRateSliderOutlet.value = lIBORnumbertoSliderValue(settings.changeInInterestRate.doubleValue)
        changeInRateAmountLabel.text = "\(settings.changeInInterestRate.integerValue)%"
        adjustedGrossIncomeTextField6.text = "$\(floor(settings.agi.doubleValue * 100) / 100)"
        annualSalaryIncreaseTextField7.text = "\(floor(settings.annualSalaryIncrease.doubleValue * 100) / 100)%"
        qualifyingJobSwitch.setOn(settings.qualifyingJob.boolValue, animated:true)
        IBRDatesSwitch10.setOn(settings.ibrDateOptions.boolValue,animated:true)//this is actually new borrower status 
        ICRDatesSwitch10.setOn(settings.icrReqs.boolValue, animated:true)
        PAYEDatesSwtich12.setOn(settings.payeReqs.boolValue, animated:true)
        repaymentTermSlider.value = self.getSliderValueFromRefiTermYears(settings.refiTerm.doubleValue)
        RepaymentTermYearLabel.text = "\(Int(settings.refiTerm.integerValue)) years"
        yearsInProgramLabel.text = "\(settings.yearsInProgram.integerValue)"
        stepperOutlet.value = settings.yearsInProgram.doubleValue
        oneTimePayoffTextFieldOutlet.text = "$\(floor(settings.oneTimePayoff.doubleValue * 100) / 100)"
        headOfHouseholdSwitch.setOn(settings.headOfHousehold.boolValue, animated:true)
    }
    
    
    @IBAction func firstCellButton(sender: AnyObject) {
        self.resignResponder()
    }
    
    @IBAction func lastCellButton(sender: UIButton) {
        self.resignResponder()
    }
    
    
    @IBAction func extraPaymentSliderAction(sender: UISlider) {
        sender.value = Float(Int(sender.value))
        switch sender.value {
        case 0:
            return extraPaymentAmountLabel.text = "Never"
        case 1:
            return extraPaymentAmountLabel.text = "1 month"
        case 2,3,4,5,6,7,8,9,10,11:
            return extraPaymentAmountLabel.text = "\(Int(sender.value)) months"
        case 12:
            return extraPaymentAmountLabel.text = "12 months"
        case 13:
            return extraPaymentAmountLabel.text = "18 months"
        case 14:
            return extraPaymentAmountLabel.text = "24 months"
        case 15:
            return extraPaymentAmountLabel.text = "30 months"
        case 16:
            return extraPaymentAmountLabel.text = "3 years"
        case 17:
            return extraPaymentAmountLabel.text = "4 years"
        case 18:
            return extraPaymentAmountLabel.text = "5 years"
        case 19:
            return extraPaymentAmountLabel.text = "Every time"
        default:
            return extraPaymentAmountLabel.text = "Every time"
        }
        
    }
    @IBOutlet weak var extraPaymentLabel: UILabel! //1
   
    @IBOutlet weak var extraPaymentSliderOutlet: UISlider! //1
    
    @IBOutlet weak var extraPaymentAmountLabel: UILabel! //1
    
    @IBOutlet weak var extraAmountPaid: UILabel! //2
    
    @IBOutlet weak var extraAmountTextField: UITextField! //2
    
    @IBOutlet weak var infoButton_ExtraAmount_2: UIButton!
    
    @IBAction func infoButton_ExtraAmount_2_Action(sender: UIButton) {
         self.performSegueWithIdentifier("modalInfoSegue", sender:"Extra Payments")
    }
    
    @IBOutlet weak var interestRateOnRefinanceLabel: UILabel! //3
    
    @IBOutlet weak var interestRateOnRefinanceTextFieldOutlet: ParkedTextField! //3
    
    @IBOutlet weak var infoButton_InterestRateIncease_5: UIButton!
    
    @IBAction func infoButton_InterestRateIncease_5_Action(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"Increases in Interest Rate")
    }
    @IBOutlet weak var variableInterestRateLabel: UILabel! //4
    
    @IBOutlet weak var variableInterestRateSwitchOutlet: UISwitch! //4
    
    @IBAction func variableInterestRateSwitchAction(sender: UISwitch) {
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var infoButtonVariableOutlet: UIButton! //4
    
    @IBAction func infoButtonVariableAction(sender: AnyObject) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"Variable Interest Rate")
    }
    
    
    @IBOutlet weak var changeinRateLabel: UILabel! //5
    
    @IBOutlet weak var changeInRateSliderOutlet: UISlider! //5
    
    @IBAction func changeInRateSliderAction(sender: UISlider) {
        sender.value = Float(Int(sender.value))
        switch sender.value {
        case 0:
            return changeInRateAmountLabel.text = "0%"
        case 1:
            return changeInRateAmountLabel.text = "1%"
        case 2:
            return changeInRateAmountLabel.text = "2%"
        case 3:
            return changeInRateAmountLabel.text = "4%"
        case 4:
            return changeInRateAmountLabel.text = "6%"
        case 5:
            return changeInRateAmountLabel.text = "8%"
        default:
            return changeInRateAmountLabel.text = "0%"
        }
    }
    
    @IBOutlet weak var changeInRateAmountLabel: UILabel! //5
    
    @IBAction func infoButton_AGI_6_Action(sender: UIButton) {
         self.performSegueWithIdentifier("modalInfoSegue", sender:"Adjusted Gross Income")
    }

    @IBOutlet weak var infoButton_AGI_6: UIButton!
   
    
    @IBOutlet weak var infoButton_SalaryIncrease_7: UIButton!
    
    @IBAction func infoButton_SalaryIncrease_7_Action(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"Annual Salary Increase")
    }
    
    @IBOutlet weak var qualifyingJobLabel: UILabel! //9
    
    @IBOutlet weak var qualifyingJobSwitch: UISwitch! //9
    
    @IBOutlet weak var infoButton_Job_9: UIButton!
    
    @IBAction func infoButton_Job_9(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"Qualifying Job")
    }
    
    @IBOutlet weak var adjustedGrossIncomeLabel6: UILabel!
    
    @IBOutlet weak var adjustedGrossIncomeTextField6: UITextField!
    
    @IBOutlet weak var annualSalaryIncreaseLabel7: UILabel!
    
    @IBOutlet weak var annualSalaryIncreaseTextField7: ParkedTextField!
    
    @IBOutlet weak var familySizeLabel8: UILabel! //8
    
   
    @IBOutlet weak var familySizeStepperOutlet: UIStepper! //8
    
    @IBOutlet weak var familySizeNumLabel: UILabel! //8
    
    @IBAction func familySizeStepper_Action(sender: UIStepper) {
        familySizeNumLabel.text = String(stringInterpolationSegment: Int(sender.value))
    } //8
    
    @IBOutlet weak var infoButton_FamilySize_8: UIButton!
    
    
    @IBAction func infoButton_FamilySize_8(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"Family Size")
    }
    
    @IBOutlet weak var IBRDatesLabel10: UILabel!
    
    @IBOutlet weak var IBRDatesSwitch10: UISwitch!
    
    @IBOutlet weak var infoButton_IBR_10: UIButton!
    
    
    @IBAction func infoButton_IBR_10_Action(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"New Borrower For IBR Program")
    }
    
    @IBOutlet weak var ICRDatesLabel10: UILabel! //11 oops.
    
    @IBAction func infoButton_ICR_11_Action(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"ICR Date Requirements")
    }
    
    @IBOutlet weak var ICRDatesSwitch10: UISwitch! //11 oops.
    @IBOutlet weak var infoButton_ICR_11: UIButton!
    
    @IBOutlet weak var PAYEDatesLabel12: UILabel!
    
    @IBOutlet weak var PAYEDatesSwtich12: UISwitch!
    
    @IBOutlet weak var infoButton_PAYE_12: UIButton!
    
    @IBAction func infoButton_PAYE_12(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"PAYE Date Requirements")
    }
    
    @IBOutlet weak var instructionsLabel: UILabel! //13
    
    @IBOutlet weak var repaymentTermLabel: UILabel! //14
    
    @IBOutlet weak var repaymentTermSlider: UISlider!
    
    @IBAction func repaymentTermSliderAction(sender: UISlider) {
        sender.value = Float(Int(sender.value))
        switch sender.value {
        case 0:
            return RepaymentTermYearLabel.text = "5 years"
        case 1:
            return RepaymentTermYearLabel.text = "7 years"
        case 2:
            return RepaymentTermYearLabel.text = "10 years"
        case 3:
            return RepaymentTermYearLabel.text = "15 years"
        case 4:
            return RepaymentTermYearLabel.text = "20 years"
        default:
            return changeinRateLabel.text = "10 years"
        }

        
    }
    
    @IBOutlet weak var RepaymentTermYearLabel: UILabel!

    
    @IBOutlet weak var yearsInProgramLabel: UILabel!

    @IBOutlet weak var stepperOutlet: UIStepper!
    

    
    @IBAction func stepperAction(sender: UIStepper) {
        switch sender.value {
        case 1:
            stepperYearsOutlet.text = "1"
        case 2:
            stepperYearsOutlet.text = "2"
        case 3:
            stepperYearsOutlet.text = "3"
        case 4:
            stepperYearsOutlet.text = "4"
        case 5:
            stepperYearsOutlet.text = "5"
        case 6:
            stepperYearsOutlet.text = "6"
        case 7:
            stepperYearsOutlet.text = "7"
        case 8:
            stepperYearsOutlet.text = "8"
        case 9:
            stepperYearsOutlet.text = "9"
        default:
            stepperYearsOutlet.text = "1"
        }
    }
    
    @IBOutlet weak var stepperYearsOutlet: UILabel!
    
    @IBOutlet weak var infoButton_YearsInProgram: UIButton!
    
    @IBAction func infoButton_YearsInProgram_Action(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"Years In Program")
    }
    @IBOutlet weak var oneTimePayoffLabel: UILabel!
    
    @IBOutlet weak var oneTimePayoffTextFieldOutlet: UITextField!
    
    @IBAction func infoButton_OneTimePayoff_Action(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue", sender:"One Time Payoff")
    }
    
    @IBOutlet weak var headOfHouseholdLabel: UILabel!
    
    
    @IBOutlet weak var headOfHouseholdSwitch: UISwitch!
    
    @IBOutlet weak var infoButton_OneTimePayoff: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        extraPaymentAmountLabel.text = "Never"
        extraPaymentSliderOutlet.maximumValue = Float(19)
        changeInRateSliderOutlet.maximumValue = Float(5)
        changeInRateAmountLabel.text = "0%"
        repaymentTermSlider.maximumValue = Float(4)
        repaymentTermSlider.value = 2
        RepaymentTermYearLabel.text = "10 years"
        //stepperYearsOutlet.text = "1 year"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Retu1n the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 19
    }
    


    
    //START HERE: FIRST, THIS TABLE NEEDS TO BE REDRAWN WHEN THE PERSON DISMISSES THE REPAYMENT PLAN SELECTION.  NEXT, THIS NEEDS TO BE WIRED UP WITH THE VARIOUS OPTIONS.  
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 30
        case 1, 2:
            if selectedRepaymentPlan == "Standard" || selectedRepaymentPlan == "Extended" || selectedRepaymentPlan == "Graduated" || selectedRepaymentPlan == "Extended Grad." {
                extraPaymentLabel.hidden = false
                extraPaymentSliderOutlet.hidden = false
                extraPaymentAmountLabel.hidden = false
                extraAmountPaid.hidden = false
                extraAmountTextField.hidden = false
                infoButton_ExtraAmount_2.hidden = false
                return 45
            }
            else{
                extraPaymentLabel.hidden = true
                extraPaymentSliderOutlet.hidden = true
                extraPaymentAmountLabel.hidden = true
                extraAmountPaid.hidden = true
                extraAmountTextField.hidden = true
                infoButton_ExtraAmount_2.hidden = true 
                return 0
            }
        case 3,4:
            if selectedRepaymentPlan == "Refi" {
                interestRateOnRefinanceLabel.hidden = false
                interestRateOnRefinanceTextFieldOutlet.hidden = false
                variableInterestRateLabel.hidden = false
                variableInterestRateSwitchOutlet.hidden = false
                infoButtonVariableOutlet.hidden = false
               // changeinRateLabel.hidden = false
               // changeInRateSliderOutlet.hidden = false
               // changeInRateAmountLabel.hidden = false
                return 45
            }
            else{
                interestRateOnRefinanceLabel.hidden = true
                interestRateOnRefinanceTextFieldOutlet.hidden = true
                variableInterestRateLabel.hidden = true
                variableInterestRateSwitchOutlet.hidden = true
                infoButtonVariableOutlet.hidden = true
              //  changeinRateLabel.hidden = true
              //  changeInRateSliderOutlet.hidden = true
              //  changeInRateAmountLabel.hidden = true
                return 0
            }
        case 5:
            if selectedRepaymentPlan == "Refi" && variableInterestRateSwitchOutlet.on {
                changeinRateLabel.hidden = false
                changeInRateSliderOutlet.hidden = false
                changeInRateAmountLabel.hidden = false
                infoButton_InterestRateIncease_5.hidden = false
                return 45
            }
            else {
                changeinRateLabel.hidden = true
                changeInRateSliderOutlet.hidden = true
                changeInRateAmountLabel.hidden = true
                infoButton_InterestRateIncease_5.hidden = true
                return 0
            }
        case 6, 7, 8:
            if selectedRepaymentPlan == "IBR with PILF" || selectedRepaymentPlan == "ICR with PILF" || selectedRepaymentPlan == "PAYE with PILF" || selectedRepaymentPlan == "IBR" || selectedRepaymentPlan == "ICR" || selectedRepaymentPlan == "PAYE" || selectedRepaymentPlan == "IBR Limited" || selectedRepaymentPlan == "PAYE Limited" || selectedRepaymentPlan == "ICR Limited" {
                adjustedGrossIncomeLabel6.hidden = false
                adjustedGrossIncomeTextField6.hidden = false
                annualSalaryIncreaseLabel7.hidden = false
                annualSalaryIncreaseTextField7.hidden = false
                familySizeLabel8.hidden = false
                familySizeStepperOutlet.hidden = false
                familySizeNumLabel.hidden = false
                infoButton_FamilySize_8.hidden = false
                infoButton_AGI_6.hidden = false
                infoButton_SalaryIncrease_7.hidden = false
                return 45
            }
            else{
                adjustedGrossIncomeLabel6.hidden = true
                adjustedGrossIncomeTextField6.hidden = true
                annualSalaryIncreaseLabel7.hidden = true
                annualSalaryIncreaseTextField7.hidden = true
                familySizeStepperOutlet.hidden = true
                familySizeNumLabel.hidden = true
                familySizeLabel8.hidden = true
                infoButton_FamilySize_8.hidden = true
                infoButton_AGI_6.hidden = true
                infoButton_SalaryIncrease_7.hidden = true
                return 0
            }

        case 9:
            if selectedRepaymentPlan == "IBR with PILF" || selectedRepaymentPlan == "ICR with PILF" || selectedRepaymentPlan == "PAYE with PILF" {
                qualifyingJobLabel.hidden = false
                qualifyingJobSwitch.hidden = false
                infoButton_Job_9.hidden = false
                return 45
            }
            else {
                qualifyingJobLabel.hidden = true
                qualifyingJobSwitch.hidden = true
                infoButton_Job_9.hidden = true
                return 0
            }
            
        case 10:
            if selectedRepaymentPlan == "IBR" || selectedRepaymentPlan == "IBR with PILF" || selectedRepaymentPlan == "IBR Limited" {
                IBRDatesLabel10.hidden = false
                IBRDatesSwitch10.hidden = false
                infoButton_IBR_10.hidden = false
                return 45
            }
            else {
                IBRDatesLabel10.hidden = true
                IBRDatesSwitch10.hidden = true
                infoButton_IBR_10.hidden = true 
                return 0
            }
        case 11:
            if selectedRepaymentPlan == "ICR" || selectedRepaymentPlan == "ICR with PILF" || selectedRepaymentPlan == "ICR Limited"{
                ICRDatesLabel10.hidden = true
                ICRDatesSwitch10.hidden = true
                infoButton_ICR_11.hidden = true
                return 0
            }
            else {
                //right now I don't see any date requirements for ICR...
                ICRDatesLabel10.hidden = true
                ICRDatesSwitch10.hidden = true
                infoButton_ICR_11.hidden = true
                return 0
            }
        case 12:
            if selectedRepaymentPlan == "PAYE" || selectedRepaymentPlan == "PAYE with PILF" ||  selectedRepaymentPlan == "PAYE Limited" {
                PAYEDatesLabel12.hidden = false
                PAYEDatesSwtich12.hidden = false
                infoButton_PAYE_12.hidden = false
                return 45
            }
            else {
                PAYEDatesLabel12.hidden = true
                PAYEDatesSwtich12.hidden = true
                infoButton_PAYE_12.hidden = true
                return 0
            }
        case 13:
            if selectedRepaymentPlan == nil {
                instructionsLabel.hidden = false
                return self.view.frame.height
            }
            else {
                instructionsLabel.hidden = true
                return 0
            }
        case 14:
            if selectedRepaymentPlan == "Refi" {
                repaymentTermSlider.hidden = false
                repaymentTermLabel.hidden = false
                RepaymentTermYearLabel.hidden = false
                return 45
            }
            else {
                repaymentTermSlider.hidden = true
                repaymentTermLabel.hidden = true
                RepaymentTermYearLabel.hidden = true
                return 0
            }
        case 15:
            if selectedRepaymentPlan == "IBR Limited" || selectedRepaymentPlan == "PAYE Limited" || selectedRepaymentPlan == "ICR Limited" {
                yearsInProgramLabel.hidden = false
                stepperOutlet.hidden = false
                stepperYearsOutlet.hidden = false
                infoButton_YearsInProgram.hidden = false
                return 45
            }
            else{
                yearsInProgramLabel.hidden = true
                stepperOutlet.hidden = true
                stepperYearsOutlet.hidden = true
                infoButton_YearsInProgram.hidden = true
                return 0
            }
        case 16:
            if selectedRepaymentPlan == "Refi"{
                oneTimePayoffLabel.hidden = false
                oneTimePayoffTextFieldOutlet.hidden = false
                infoButton_OneTimePayoff.hidden = false
                return 45
            }
            else{
                oneTimePayoffLabel.hidden = true
                oneTimePayoffTextFieldOutlet.hidden = true
                infoButton_OneTimePayoff.hidden = true
                return 0 
            }
        case 17:
             if selectedRepaymentPlan == "ICR" || selectedRepaymentPlan == "ICR with PILF" || selectedRepaymentPlan == "ICR Limited"{
                headOfHouseholdLabel.hidden = false
                headOfHouseholdSwitch.hidden = false
                return 45}
             else {
                headOfHouseholdLabel.hidden = true
                headOfHouseholdSwitch.hidden = true
                return 0
            }
        case 18:
            return self.view.frame.height - 90
        default:
            return self.view.frame.height
            
        }
    }
    
    func resignResponder(){
        extraAmountTextField.resignFirstResponder()
        interestRateOnRefinanceTextFieldOutlet.resignFirstResponder()
        adjustedGrossIncomeTextField6.resignFirstResponder()
        annualSalaryIncreaseLabel7.resignFirstResponder()
        oneTimePayoffTextFieldOutlet.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignResponder()
    }
    
    
    override func prepareForSegue
        (segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if segue.identifier == "modalInfoSegue" {
                let option = sender as! String
                var vc:PlanOptionsInfo = segue.destinationViewController as! PlanOptionsInfo
                vc.labelText = option
            }
    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
