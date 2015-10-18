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
        //reload the table, because now you'll want other rows to show
    }
    
    @IBOutlet weak var changeinRateLabel: UILabel! //5
    
    @IBOutlet weak var changeInRateSliderOutlet: UISlider! //5
    
    @IBAction func changeInRateSliderAction(sender: UISlider) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 14
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
        case 3,4,5:
            if selectedRepaymentPlan == "Refi" {
                interestRateOnRefinanceLabel.hidden = false
                interestRateOnRefinanceTextFieldOutlet.hidden = false
                variableInterestRateLabel.hidden = false
                variableInterestRateSwitchOutlet.hidden = false
                changeinRateLabel.hidden = false
                changeInRateSliderOutlet.hidden = false
                changeInRateAmountLabel.hidden = false
                return 45
            }
            else{
                interestRateOnRefinanceLabel.hidden = true
                interestRateOnRefinanceTextFieldOutlet.hidden = true
                variableInterestRateLabel.hidden = true
                variableInterestRateSwitchOutlet.hidden = true
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
