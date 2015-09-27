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
    
        self.tableView.reloadData()
        println("got into viewdidappear")
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
        var cell = tableView.dequeueReusableCellWithIdentifier("loanCellRedux") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "loanCellRedux")}
        let newLoan = myLoans[indexPath.row] as! Loan
        println(indexPath.row)
        cell!.textLabel!.text = newLoan.valueForKey("name") as? String
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("segueToEnteredLoan", sender: indexPath);
    }
    
    override func prepareForSegue
        (segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if segue.identifier == "segueToEnteredLoan" {
                let indexPath = tableView.indexPathForSelectedRow()!
                
                let selectedLoan = myLoans[indexPath.row] as! Loan
                println(selectedLoan.monthsInRepaymentTerm)
                println(selectedLoan.monthsUntilRepayment)
                var vc:EnteredViewController = segue.destinationViewController as! EnteredViewController
                vc.clickedLoan = selectedLoan
                println(selectedLoan.name)
               
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
            loanToRemove.deleteLoanFromDefaultScenario(managedObjectContext)
            //2
            managedObjectContext.deleteObject(loanToRemove as NSManagedObject)
            //3
            if !managedObjectContext.save(&error) {
                println("Could not save: \(error)") }
            //4
                //TODO:Fix this so that the loans properly re-allign.  This is throwing off the deleting process right now 
            self.tableView.reloadData()
        }
    }

}
