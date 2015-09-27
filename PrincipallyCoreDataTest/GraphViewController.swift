//
//  GraphViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 9/22/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class GraphViewController: UIViewController {

    var mystring : String = "did not work"
    var interest : NSNumber = 0
    var balance : NSNumber = 0
    var name : String = ""
    var type : String = ""
    var segmentedEntryType : Int = 0
    var pickerMonth : String = ""
    var pickerYear : String = ""
    var sliderTerm : NSNumber = 0
    var monthlyAmount : NSNumber = 0
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    @IBOutlet weak var testLabel1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func graphFlippedAroundVisible(){
        //Step 1: Wind up the loan, save it
        //pull entity within the managedObjectContext of "loan"
        let entity = NSEntityDescription.entityForName("Loan", inManagedObjectContext: managedObjectContext)
        //set variable of what will be inserted into the entity "Loan"
        let firstLoan = Loan(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        //Set the characteristics of what will be added
        firstLoan.name = name as String
        firstLoan.balance = balance
        firstLoan.interest = interest
        firstLoan.loanType = type
        
        switch segmentedEntryType {
        case 0:
            firstLoan.monthsInRepaymentTerm = sliderTerm
            firstLoan.monthsUntilRepayment = firstLoan.getMonthsUntilRepayment(pickerMonth, year:pickerYear)
            if firstLoan.monthsUntilRepayment.integerValue + firstLoan.monthsInRepaymentTerm.integerValue < 1 {
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "Your loan should be paid off already based on the dates you entered"
                alert.addButtonWithTitle("Understood")
                alert.show()
            }else{
                firstLoan.enterLoanByDate(managedObjectContext)
                var error: NSError?
                if !managedObjectContext.save(&error) {
                    println("Could not save \(error), \(error?.userInfo)")
                }
            }
        case 1:
            firstLoan.defaultMonthlyPayment = monthlyAmount
            firstLoan.enteredLoanByPayment(managedObjectContext)
            firstLoan.monthsUntilRepayment = 0
            var error: NSError?
            if !managedObjectContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }

        default:
            break;
        }
        
        //Step 2: Make a graph of the loan
        //START HERE -- SET UP STORYBOARD OF THE GRAPH CONTAINER
    }
    
    func graphFlippedAroundNotVisible(){
        //NEXT TODO: DELETE THE LOAN THAT HAS JUST BEEN ENTERED. 
       //Delete the loan that you've just entered?
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
