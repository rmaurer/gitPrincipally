//
//  PaymentContainerTableViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 8/13/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class PaymentContainerTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    var delegate:SaveButtonDelegate? = nil
    
    @IBOutlet weak var saveLoanButtonOutlet: UIButton!
    
    @IBAction func saveLoanButtonAction(sender: UIButton) {
        delegate!.didPressSaveOrEditButton()
    }
    
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    
    @IBAction func segmentedAction(sender: UISegmentedControl) {
        //resind first responder
        self.view.endEditing(true)
        switch sender.selectedSegmentIndex {
        case 0:
            pickerOutlet.hidden = false
        case 1:
            pickerOutlet.hidden = true
        default:
            break;}

        self.tableView.reloadData()
    }
    
    @IBOutlet weak var monthsAlreadyPaidLabel: UILabel!
    
    @IBOutlet weak var alreadyPaidStepper: UIStepper!
    @IBAction func alreadyPaidStepperAction(sender: UIStepper) {
        monthsAlreadyPaidLabel.text = String(Int(sender.value))
    }
    
   
  
    @IBOutlet weak var TermLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!

    
    
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    
    @IBOutlet weak var pickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerOutlet.dataSource = self
        pickerOutlet.delegate = self
        pickerOutlet.selectRow(1, inComponent: 0, animated: true)
        pickerOutlet.selectRow(25, inComponent: 1, animated: true)
        

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
        // Return the number of sections.
        return 1
    }

    @IBAction func saveButton(sender: AnyObject) {
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }
    
    
    override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        
        switch indexPath.row{
        case 0:
            return 60
        case 1:
            if segmentedOutlet.selectedSegmentIndex == 0 {
                TermLabel.hidden = false
                monthsAlreadyPaidLabel.hidden = false
                infoButtonMonthsAlreadyPaidOutlet.hidden = false
                alreadyPaidStepper.hidden = false
                dateLabel.hidden = true
                pickerOutlet.hidden = true
            if tableView.frame.size.height - 130 < 60 {
                    self.tableView.scrollEnabled = true
                }
                else {
                    self.tableView.scrollEnabled = false
                }

                return 120
            }
            else{
                //self.tableView.scrollEnabled = false
                return 0}
        case 2:
            if segmentedOutlet.selectedSegmentIndex == 0 {
                //self.tableView.scrollEnabled = false
                return 0

            }
            else{
                TermLabel.hidden = true
                monthsAlreadyPaidLabel.hidden = true
                infoButtonMonthsAlreadyPaidOutlet.hidden = true
                alreadyPaidStepper.hidden = true
                dateLabel.hidden = false
                pickerOutlet.hidden = false
                var amount = maxElement([125, tableView.frame.size.height - 120])
                if 125 > tableView.frame.size.height - 120 {
                    self.tableView.scrollEnabled = true
                }
                else {
                    self.tableView.scrollEnabled = false
                }
                return amount
            }
        case 3:
            return 60
        case 4:
            return maxElement([tableView.frame.size.height - 180, 0])
        default:
            return 0
        }
    }

    @IBOutlet weak var infoButtonMonthsAlreadyPaidOutlet: UIButton!
    
    @IBAction func infoButtonMonthsAlreadyPaidAction(sender: UIButton) {
        self.performSegueWithIdentifier("modalInfoSegue2", sender:"Loan Payment Information")
    }
    
    
    override func tableView(tableView:UITableView, estimatedHeightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        return 200
    }

    let pickerData = [
        ["January", "February","March","April","May","June","July","August","September","October","November","December"],
        ["2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030"]
    ]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //updateLabel()
    }
    
    override func prepareForSegue
        (segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if segue.identifier == "modalInfoSegue2" {
                let option = "Loan Payment Information"
                var vc:PlanOptionsInfo = segue.destinationViewController as! PlanOptionsInfo
                vc.labelText = option
            }
    }
    


}
