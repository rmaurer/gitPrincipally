//
//  PaymentContainerTableViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 8/13/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class PaymentContainerTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{

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
    
    @IBOutlet weak var termViewContainer: UIView!
    
    @IBOutlet weak var termYearsLabel: UILabel!
  
    @IBOutlet weak var TermLabel: UILabel!
    
    @IBOutlet weak var termSlider: UISlider!
    
    @IBAction func termSliderAction(sender: UISlider) {
        var sliderByFives = Int(sender.value/5) * 5
        sender.value = Float(sliderByFives)
        termYearsLabel.text = "\(sliderByFives) years"
    }
    
    @IBOutlet weak var dateLabel: UILabel!

    
    
    @IBOutlet weak var pickerOutlet: UIPickerView!
    
    
    @IBOutlet weak var montlyAmountLabel: UILabel!
    
    @IBOutlet weak var monthlyAmountTextField: UITextField!
    
    
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
                termYearsLabel.hidden = false
                TermLabel.hidden = false
                termSlider.hidden = false
                dateLabel.hidden = false
                pickerOutlet.hidden = false
                termViewContainer.hidden = false
                pickerView.hidden = false
                montlyAmountLabel.hidden = true
                monthlyAmountTextField.hidden = true
                return 45
            }
            else{
                return 0}
        case 2:
            if segmentedOutlet.selectedSegmentIndex == 0 {
                return tableView.frame.size.height - 120
            }
            else{
                return 0}
        case 3:
            if segmentedOutlet.selectedSegmentIndex == 0 {
                return 0
            }
            else{
                termYearsLabel.hidden = true
                TermLabel.hidden = true
                termSlider.hidden = true
                dateLabel.hidden = true
                pickerOutlet.hidden = true
                pickerView.hidden = true
                termViewContainer.hidden = true
                montlyAmountLabel.hidden = false
                monthlyAmountTextField.hidden = false
                return 45
            }
        case 4:
            //return 0
            if segmentedOutlet.selectedSegmentIndex == 0 {
                return  0
            }
            else{
                return tableView.frame.size.height - 90}
        default:
            return 0
        }
    }

    override func tableView(tableView:UITableView, estimatedHeightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        return 200
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

    
    // Override to support conditional rearranging of the table view.
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    //picker material
    let pickerData = [
        ["January", "February","March","April","May","June","July","August","September","October","November","December"],
        ["1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030"]
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


}
