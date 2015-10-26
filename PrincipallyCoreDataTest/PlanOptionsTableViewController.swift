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
    
    @IBOutlet weak var interestRateOnRefinanceLabel: UILabel! //3
    
    @IBOutlet weak var interestRateOnRefinanceTextFieldOutlet: ParkedTextField! //3
    
    @IBOutlet weak var variableInterestRateLabel: UILabel! //4
    
    @IBOutlet weak var variableInterestRateSwitchOutlet: UISwitch! //4
    
    @IBAction func variableInterestRateSwitchAction(sender: UISwitch) {
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var changeinRateLabel: UILabel! //5
    
    @IBOutlet weak var changeInRateSliderOutlet: UISlider! //5
    
    @IBAction func changeInRateSliderAction(sender: UISlider) {
        sender.value = Float(Int(sender.value))
        switch sender.value {
        case 0:
            return changeInRateAmountLabel.text = "No Change"
        case 1:
            return changeInRateAmountLabel.text = "1% Increase"
        case 2:
            return changeInRateAmountLabel.text = "2% Increase"
        case 3:
            return changeInRateAmountLabel.text = "4% Increase"
        case 4:
            return changeInRateAmountLabel.text = "6% Increase"
        case 5:
            return changeInRateAmountLabel.text = "8% Increase"
        default:
            return changeInRateAmountLabel.text = "No Change"
        }
    }
    
    @IBOutlet weak var changeInRateAmountLabel: UILabel! //5
    

    @IBOutlet weak var qualifyingJobLabel: UILabel! //9
    
    @IBOutlet weak var qualifyingJobSwitch: UISwitch! //9
    
    @IBOutlet weak var adjustedGrossIncomeLabel6: UILabel!
    
    @IBOutlet weak var adjustedGrossIncomeTextField6: UITextField!
    
    @IBOutlet weak var annualSalaryIncreaseLabel7: UILabel!
    
    @IBOutlet weak var annualSalaryIncreaseTextField7: ParkedTextField!
    
    @IBOutlet weak var familySizeLabel8: UILabel!
    
    @IBOutlet weak var familySizeTextField8: UITextField!
    
    
    @IBOutlet weak var IBRDatesLabel10: UILabel!
    
    @IBOutlet weak var IBRDatesSwitch10: UISwitch!
    
    @IBOutlet weak var ICRDatesLabel10: UILabel! //11 oops.
    
    @IBOutlet weak var ICRDatesSwitch10: UISwitch! //11 oops.
    
    @IBOutlet weak var PAYEDatesLabel12: UILabel!
    
    @IBOutlet weak var PAYEDatesSwtich12: UISwitch!
    
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
            stepperYearsOutlet.text = "1 year"
        case 2:
            stepperYearsOutlet.text = "2 years"
        case 3:
            stepperYearsOutlet.text = "3 years"
        case 4:
            stepperYearsOutlet.text = "4 years"
        case 5:
            stepperYearsOutlet.text = "5 years"
        case 6:
            stepperYearsOutlet.text = "6 years"
        case 7:
            stepperYearsOutlet.text = "7 years"
        case 8:
            stepperYearsOutlet.text = "8 years"
        case 9:
            stepperYearsOutlet.text = "9 years"
        default:
            stepperYearsOutlet.text = "1 year"
        }
    }
    
    @IBOutlet weak var stepperYearsOutlet: UILabel!
    
    
    @IBOutlet weak var oneTimePayoffLabel: UILabel!
    
    @IBOutlet weak var oneTimePayoffTextFieldOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extraPaymentAmountLabel.text = "Never"
        extraPaymentSliderOutlet.maximumValue = Float(19)
        changeInRateSliderOutlet.maximumValue = Float(5)
        changeInRateAmountLabel.text = "No Change"
        repaymentTermSlider.maximumValue = Float(4)
        repaymentTermSlider.value = 2
        RepaymentTermYearLabel.text = "10 years"
        stepperYearsOutlet.text = "1 year"
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
        return 17
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
                return 45
            }
            else{
                extraPaymentLabel.hidden = true
                extraPaymentSliderOutlet.hidden = true
                extraPaymentAmountLabel.hidden = true
                extraAmountPaid.hidden = true
                extraAmountTextField.hidden = true
                return 0
            }
        case 3,4:
            if selectedRepaymentPlan == "Refi" {
                interestRateOnRefinanceLabel.hidden = false
                interestRateOnRefinanceTextFieldOutlet.hidden = false
                variableInterestRateLabel.hidden = false
                variableInterestRateSwitchOutlet.hidden = false
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
                return 45
            }
            else {
                changeinRateLabel.hidden = true
                changeInRateSliderOutlet.hidden = true
                changeInRateAmountLabel.hidden = true
                return 0
            }
        case 6, 7, 8:
            if selectedRepaymentPlan == "IBR with PILF" || selectedRepaymentPlan == "ICR with PILF" || selectedRepaymentPlan == "PAYE with PILF" || selectedRepaymentPlan == "IBR" || selectedRepaymentPlan == "ICR" || selectedRepaymentPlan == "PAYE"  {
                adjustedGrossIncomeLabel6.hidden = false
                adjustedGrossIncomeTextField6.hidden = false
                annualSalaryIncreaseLabel7.hidden = false
                annualSalaryIncreaseTextField7.hidden = false
                familySizeLabel8.hidden = false
                familySizeTextField8.hidden = false
                return 45
            }
            else{
                adjustedGrossIncomeLabel6.hidden = true
                adjustedGrossIncomeTextField6.hidden = true
                annualSalaryIncreaseLabel7.hidden = true
                annualSalaryIncreaseTextField7.hidden = true
                familySizeLabel8.hidden = true
                familySizeTextField8.hidden = true
                return 0
            }

        case 9:
            if selectedRepaymentPlan == "IBR with PILF" || selectedRepaymentPlan == "ICR with PILF" || selectedRepaymentPlan == "PAYE with PILF" {
                qualifyingJobLabel.hidden = false
                qualifyingJobSwitch.hidden = false
                return 45
            }
            else {
                qualifyingJobLabel.hidden = true
                qualifyingJobSwitch.hidden = true
                return 0
            }
            
        case 10:
            if selectedRepaymentPlan == "IBR" || selectedRepaymentPlan == "IBR with PILF"{
                IBRDatesLabel10.hidden = false
                IBRDatesSwitch10.hidden = false
                return 45
            }
            else {
                IBRDatesLabel10.hidden = true
                IBRDatesSwitch10.hidden = true
                return 0
            }
        case 11:
            if selectedRepaymentPlan == "ICR" || selectedRepaymentPlan == "ICR with PILF"{
                ICRDatesLabel10.hidden = false
                ICRDatesSwitch10.hidden = false
                return 45
            }
            else {
                ICRDatesLabel10.hidden = true
                ICRDatesSwitch10.hidden = true
                return 0
            }
        case 12:
            if selectedRepaymentPlan == "PAYE" || selectedRepaymentPlan == "PAYE with PILF" {
                PAYEDatesLabel12.hidden = false
                PAYEDatesSwtich12.hidden = false
                return 45
            }
            else {
                PAYEDatesLabel12.hidden = true
                PAYEDatesSwtich12.hidden = true
                return 0
            }
        case 13:
            if selectedRepaymentPlan == nil {
                instructionsLabel.hidden = false
                return 60
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
            if selectedRepaymentPlan == "" {
                yearsInProgramLabel.hidden = false
                stepperOutlet.hidden = false
                stepperYearsOutlet.hidden = false
                return 45
            }
            else{
                yearsInProgramLabel.hidden = true
                stepperOutlet.hidden = true
                stepperYearsOutlet.hidden = true
                return 0
            }
        case 16:
            if selectedRepaymentPlan == "Refi"{
                oneTimePayoffLabel.hidden = false
                oneTimePayoffTextFieldOutlet.hidden = false
                return 45
            }
            else{
                oneTimePayoffLabel.hidden = true
                oneTimePayoffTextFieldOutlet.hidden = true
                return 0 
            }
        case 17:
            return self.tableView.frame.size.height
        default:
            return 45
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
