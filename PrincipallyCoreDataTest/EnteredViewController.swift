//
//  EnteredViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 6/25/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class EnteredViewController: UIViewController {

    //TODO: Add storyboard and view with all the pertinent loan information 
    //We aren't going to allow loans to be editable -- you can just delete and reenter.  if you're going to edit the repayment terms, that should be done through 
    
    @IBOutlet weak var loanName: UILabel!
   
    @IBOutlet weak var loanType: UILabel!
    @IBOutlet weak var loanBalance: UILabel!
    @IBOutlet weak var loanInterest: UILabel!
    @IBOutlet weak var graphOfEnteredLoan: GraphOfEnteredLoan!
    
    @IBAction func graphSlider(sender: UISlider) {
        sender.value = floor(sender.value)
        let totalMonths = clickedLoan!.monthsInRepaymentTerm.floatValue - clickedLoan!.monthsUntilRepayment.floatValue
        //graphOfEnteredLoan.CAWhiteLine.timeOffset = CFTimeInterval(sender.value / totalMonths)
        
        let mpForThisLoan = clickedLoan!.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        var thisLoan = mpForThisLoan[Int(sender.value)] as! MonthlyPayment
        var monthAndYear = clickedLoan!.getStringOfYearAndMonthForPaymentNumber(Double(sender.value))
        paymentDescription.text = "This is payment number #\(sender.value) to be paid in \(monthAndYear), which consist of principal $\(thisLoan.principal) and $\(thisLoan.interest) in interest, for a total of $\(thisLoan.totalPayment)"
        println(sender.value)
    }
    
    @IBOutlet weak var paymentDescription: UITextView!
    
    @IBOutlet weak var graphSliderOutlet: UISlider!
    
    var clickedLoan:Loan? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        loanName.text = clickedLoan?.name
        loanType.text = clickedLoan?.loanType
        loanBalance.text = "$\(clickedLoan!.balance.stringValue)"
        loanInterest.text = "\(clickedLoan!.interest.stringValue)%"
        let tenthOfTheWay = (clickedLoan!.monthsInRepaymentTerm.floatValue - clickedLoan!.monthsUntilRepayment.floatValue)/10
        graphOfEnteredLoan.enteredLoan = clickedLoan
        graphSliderOutlet.maximumValue = clickedLoan!.defaultTotalLoanMonths.floatValue - 1
        graphSliderOutlet.setValue(0, animated: true)
        //graphOfEnteredLoan.CAWhiteLine.duration = NSTimeInterval(clickedLoan!.monthsInRepaymentTerm.floatValue - clickedLoan!.monthsUntilRepayment.floatValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
