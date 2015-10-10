//
//  RepaymentExtraTableViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/1/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

protocol ChildViewControllerDelegate {
    func updateScenarios(childViewController:RepaymentExtraTableViewController)
}

class RepaymentExtraTableViewController: UITableViewController {
    
    var delegate:ChildViewControllerDelegate?

    var parentView = RepaymentViewController()
    
    @IBAction func recalculateButton(sender: UIButton) {
        self.delegate?.updateScenarios(self)
        //parentView.updateScenarios()
    }
    @IBOutlet weak var extraAmountOutlet: UITextField!
    
    
    @IBAction func extraAmountAction(sender: UITextField) {
    }
    
    @IBOutlet weak var frequencySliderOutlet: UISlider!
    
    @IBAction func frequencySlider(sender: UISlider) {
        sender.value = Float(Int(sender.value))
        switch sender.value {
        case 0:
            return frequencyLabelOutlet.text = "Never"
        case 1:
            return frequencyLabelOutlet.text = "1 month"
        case 2,3,4,5,6,7,8,9,10,11:
            return frequencyLabelOutlet.text = "\(Int(sender.value)) months"
        case 12:
            return frequencyLabelOutlet.text = "12 months"
        case 13:
            return frequencyLabelOutlet.text = "18 months"
        case 14:
            return frequencyLabelOutlet.text = "24 months"
        case 15:
            return frequencyLabelOutlet.text = "30 months"
        case 16:
            return frequencyLabelOutlet.text = "3 years"
        case 17:
            return frequencyLabelOutlet.text = "4 years"
        case 18:
            return frequencyLabelOutlet.text = "5 years"
        case 19:
            return frequencyLabelOutlet.text = "Every time"
        default:
            return frequencyLabelOutlet.text = "Every time"
        }
    }
    
    @IBOutlet weak var frequencyLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frequencyLabelOutlet.text = "Never"
        //parentView = self.parentViewController as! RepaymentViewController
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
        return 4
    }
    
     override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 15
        case 1:
            return 45
        case 2:
            return 45
        case 3:
            return 45
        default:
            return 0
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
