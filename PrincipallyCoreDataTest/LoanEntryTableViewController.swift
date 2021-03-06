//
//  LoanEntryTableViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 6/25/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData 

class LoanEntryTableViewController: UITableViewController {
    
    var myLoans = NSOrderedSet()
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    var defaultScenario: Scenario!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        myLoans = defaultScenario.allLoans

        let height = maxElement([self.tableView.frame.height, 450])
        let width = self.tableView.frame.width
        
        
        var dynamicView = firstUseOfTableViewReminder(frame:CGRectMake(0,0,width,height))
        dynamicView.tag = 10112
        //println("viewDidAppear was used")
        
        if myLoans.count == 0 {
            //println("myloans - 0")
            dynamicView.backgroundColor=UIColor.whiteColor()
            var label = UILabel(frame: CGRectMake(0, 0, 200, 400))
            label.center = CGPointMake(width/2, 150)
            //label.textAlignment = NSTextAlignment.Center
            label.text = "Welcome! To get started, you will need to enter information on your federal loans.  If you are not sure how much you owe, talk to your loan servicers, or try going to the Department of Education's National Student Loan Data System.  Once you have all the information, get started by using the plus button above.  Then switch over to the repayment half of the program to explore the repayment options."
            
            //Remember, this program cannot guarantee your repayment plans.  We make various assumptions, and this program is only meant to provide an estimate."
            label.font = UIFont(name: label.font.fontName, size: 13)
            label.numberOfLines = 0
            label.textColor = UIColor.lightGrayColor()
            dynamicView.addSubview(label)
            
            var warningImage: UIImageView
            warningImage = UIImageView(frame:CGRectMake(0, 0, 35, 35));
            warningImage.image = UIImage(named:"WarningIcon.png")
            warningImage.contentMode = UIViewContentMode.ScaleAspectFit
            warningImage.center = CGPointMake(width/2, 295)
                
                //CGPointMake(50, height-80)
            
            dynamicView.addSubview(warningImage)
            
            
            var warningLabel = UILabel(frame: CGRectMake(0, 0, 225, 110))
            warningLabel.center = CGPointMake(width/2, 370)//CGPointMake((width-85)/2 + 65, height-60)
            //label.textAlignment = NSTextAlignment.Center
            warningLabel.text = "This program can only provide estimatations.  Your servicer will make final determinations as to eligibility and payment schedules.  Additionally, this program is still in beta. If you believe a calculation is in error, please let us know at principallyapp.com."
            warningLabel.font = UIFont(name: label.font.fontName, size: 12)
            warningLabel.numberOfLines = 0
            warningLabel.textColor = UIColor.blackColor()
            dynamicView.addSubview(warningLabel)

            
            
            
            
            dynamicView.hidden = false
            self.view.addSubview(dynamicView)
        }
        else {
            //println("myloans don't equal 0")
            for child in self.view.subviews {
                if child.tag == 10112 {
                    child.removeFromSuperview()
                }
                
            }
           // dynamicView.frame = CGRectMake(0, 0, 0, 0)
           // dynamicView.removeFromSuperview()
            self.tableView.reloadData()
        }
        
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
        return myLoans.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //println("got into cell for Row at Index Path")
        var cell = tableView.dequeueReusableCellWithIdentifier("loanCellRedux") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "loanCellRedux")}
        let newLoan = myLoans[indexPath.row] as! Loan
        //println(indexPath.row)
        cell!.textLabel!.text = newLoan.valueForKey("name") as? String
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("cellPressSegue", sender: indexPath);
    }
    
    override func prepareForSegue
        (segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if segue.identifier == "cellPressSegue" {
                let indexPath = tableView.indexPathForSelectedRow()!
                
                let selectedLoan = myLoans[indexPath.row] as! Loan
                var vc:TestLoanEntryViewController = segue.destinationViewController as! TestLoanEntryViewController
                vc.selectedLoan = selectedLoan
             }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle
        editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var error: NSError?

        if editingStyle == UITableViewCellEditingStyle.Delete {
            //1
            let loanToRemove = myLoans[indexPath.row] as! Loan
            //loanToRemove.deleteLoanFromDefaultScenario(managedObjectContext)
            //2
            managedObjectContext.deleteObject(loanToRemove as NSManagedObject)
            //3
            if !managedObjectContext.save(&error) {
                println("Could not save: \(error)") }
            //4
                //TODO:Fix this so that the loans properly re-allign.  This is throwing off the deleting process right now 
            myLoans = defaultScenario.allLoans
            self.tableView.reloadData()
        }
    }

}
