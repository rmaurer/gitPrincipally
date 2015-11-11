//
//  TestLoanEntryViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/26/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

protocol TypeViewDelegate{
    func chooseTypeDidFinish(type:String)
}

protocol SaveButtonDelegate{
    func didPressSaveOrEditButton()
}

protocol EditButtonDelegate {
    func didPressSaveOrEditButton()
}


class TestLoanEntryViewController: UIViewController,UITextFieldDelegate, TypeViewDelegate, SaveButtonDelegate,EditButtonDelegate  {
    //BalanceInterestDelgate
    
    //Flipping view when loan is entered
    
    var loanIsEnteredGraphIsShowing : Bool = false
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    var BIView = BalanceInterestTableViewController()
    var paymentView = PaymentContainerTableViewController()
    var graphView = GraphViewController()
    var editAddanotherView = EditAddAnotherScreenViewController()
    var selectedLoan: Loan?
    var firstLoan : Loan!
    
    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var entryContainer: UIView!
    
    func didPressSaveOrEditButton() {

        loadChildViews()
        self.loanNameOutlet.resignFirstResponder()
        BIView.interest.resignFirstResponder()
        BIView.balance.resignFirstResponder()

        
        if loanIsEnteredGraphIsShowing {
            graphFlippedAroundNotVisibleDeleteLoan()
            UIView.transitionFromView(graphContainer,
                toView: entryContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            //sender.title = "Save Loan"
            selectLoantype.enabled = true
            BIView.interest.userInteractionEnabled = true
            BIView.balance.userInteractionEnabled = true
            loanNameOutlet.userInteractionEnabled = true
            editingPen.hidden = false
            selectedLoan = nil 
            loanIsEnteredGraphIsShowing = !loanIsEnteredGraphIsShowing
        }
        else {
         let testinterest = getNSNumberFromString(BIView.interest.text)
         let testbalance = getNSNumberFromString(BIView.balance.text)
         let testname = getLoanName()
         let testtype = getLoanType()
            
            //Just making sure there isn't an error in the interest/balance inputs.  Granted, this is super messy, but it works for now
         if testinterest != -1 && testbalance != -1 && testtype != "Select Loan Type" && testname != "Loan Name"{
                addSimpleLoan()
                UIView.transitionFromView(entryContainer,
                    toView: graphContainer,
                    duration: 1.0,
                    options: UIViewAnimationOptions.TransitionFlipFromRight
                        | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
                //sender.title = ""
                selectLoantype.enabled = false
                BIView.interest.userInteractionEnabled = false
                BIView.balance.userInteractionEnabled = false
                loanNameOutlet.userInteractionEnabled = false
                editingPen.hidden = true
                loanIsEnteredGraphIsShowing = !loanIsEnteredGraphIsShowing
            }
            
        }
    
    }
    
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    
    func flipAroundWithoutLoadingLoan(){
        loadChildViews()
        loanNameOutlet?.text = selectedLoan!.name
        BIView.balance.text = "$\(selectedLoan!.balance)"
        BIView.interest.text = "\(selectedLoan!.interest)%"
        BIView.interest.userInteractionEnabled = false
        BIView.balance.userInteractionEnabled = false
        selectLoantype.setTitle(selectedLoan!.loanType, forState: .Normal)
        selectLoantype.enabled = false
        loanNameOutlet.userInteractionEnabled = false
        editingPen.hidden = true
        if selectedLoan!.monthsUntilRepayment.integerValue < 0 {
            editAddanotherView.descriptionLabel.text = "This loan has already entered repayment so far \(selectedLoan!.monthsUntilRepayment.integerValue * -1) payments have been made so far"
        }
        else if selectedLoan!.monthsUntilRepayment.integerValue == 0 {
            editAddanotherView.descriptionLabel.text = "This loan has just entered repayments.  No payments have been made yet."}
        else if selectedLoan!.monthsUntilRepayment.integerValue == 1 {
            editAddanotherView.descriptionLabel.text = "This loan has just entered repayments.  One payment has been made so far"}
        else {
            editAddanotherView.descriptionLabel.text = "This loan will enter payment in \(selectedLoan!.getStringOfYearAndMonthForPaymentNumber(selectedLoan!.monthsUntilRepayment.doubleValue))"
        }
        
        
        
        UIView.transitionFromView(entryContainer,
            toView: graphContainer,
            duration: 1.0,
            options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
        loanIsEnteredGraphIsShowing = !loanIsEnteredGraphIsShowing
    }
    
    
    
    //Name
    @IBOutlet weak var editingPen: UIImageView!
    
    @IBOutlet weak var loanNameOutlet: UITextField!
    
    @IBAction func loanNameEditingChanged(sender: AnyObject) {
        editingPen.hidden = true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        let maxLength = 15
        let currentString: NSString = textField.text
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    //Select Loan Type
    let loanVC = TypeModalVC(nibName: "TypeModalVC", bundle: nil)
    
    @IBOutlet weak var selectLoanUIView: SelectLoanTypeView!
    
    @IBOutlet weak var selectLoantype: UIButton!
    
    @IBAction func selectLoanTypeAction(sender: UIButton) {
        loanVC.delegate = self
        loanVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(loanVC, animated: true, completion: nil)
        
    }
    
    func chooseTypeDidFinish(type:String){
        self.selectLoantype.setTitle(type, forState: .Normal)
        self.selectLoantype.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.selectLoanUIView.dashedBorder.lineDashPattern = [1,0]
        self.selectLoanUIView.dashedBorder.setNeedsDisplay()
    }


    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        loanNameOutlet.delegate = self
        editingPen.hidden = false
        loadChildViews()
        paymentView.delegate = self
        editAddanotherView.delegate = self
        let loanNum = CoreDataStack.getNumberOfLoans(CoreDataStack.sharedInstance)() + 1
        loanNameOutlet.text = "Loan #\(String(loanNum))"
        if selectedLoan != nil {
            println("selectedLoan did not equal nil")
            flipAroundWithoutLoadingLoan()
        }
        
    }
    

    
    func loadChildViews() {
        println("loadchildViews was run")
        //grab each of the views that we're going to need
        BIView = self.childViewControllers[0] as! BalanceInterestTableViewController
        paymentView = self.childViewControllers[2] as! PaymentContainerTableViewController
        editAddanotherView = self.childViewControllers[1] as! EditAddAnotherScreenViewController

        

        //balanceInterestVC.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNSNumberFromString(input:String) -> NSNumber {
        var cleaninput = input.stringByReplacingOccurrencesOfString("%", withString: "", options: .allZeros, range:nil)
        cleaninput = cleaninput.stringByReplacingOccurrencesOfString("$", withString: "", options: .allZeros, range:nil)
        println(cleaninput)
        if NSString(string: cleaninput).length == 0 {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please enter a number for your current balance and interest rate"
            alert.addButtonWithTitle("Understood")
            alert.show()
            return -1
        }
        else if let number = NSNumberFormatter().numberFromString(cleaninput){
            return number
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please make sure your current balance and interest rate are decimal numbers "
            alert.addButtonWithTitle("Understood")
            alert.show()
            return -1
    }
}
    func getLoanType() -> String {
        if selectLoantype.currentTitle! != "Select Loan Type" {
            return selectLoantype.currentTitle!
        }
        else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please select a loan type"
            alert.addButtonWithTitle("Understood")
            alert.show()
            return "Select Loan Type"
        }
    }
    
    func getLoanName() -> String {
        if self.loanNameOutlet.text != "Loan Name"{
            return self.loanNameOutlet.text}
            
        else { let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Please enter a unique loan name"
            alert.addButtonWithTitle("Understood")
            alert.show()
            return "Loan Name"
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        loadChildViews()
        self.loanNameOutlet.resignFirstResponder()
        BIView.interest.resignFirstResponder()
        BIView.balance.resignFirstResponder()
    }
    
    
    
    func addSimpleLoan(){
        //Step 1: Wind up the loan, save it
        //pull entity within the managedObjectContext of "loan"
        let entity = NSEntityDescription.entityForName("Loan", inManagedObjectContext: managedObjectContext)
        //set variable of what will be inserted into the entity "Loan"
        firstLoan = Loan(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)

        

        //Set the characteristics of what will be added
        firstLoan.name = getLoanName() as String
        firstLoan.balance = getNSNumberFromString(BIView.balance.text)
        firstLoan.interest = getNSNumberFromString(BIView.interest.text)
        firstLoan.loanType = getLoanType() as String
        var defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        firstLoan.thisLoansScenario = defaultScenario
        
        switch paymentView.segmentedOutlet.selectedSegmentIndex {
        case 0:
            firstLoan.monthsUntilRepayment = NSNumber(double: floor(paymentView.alreadyPaidStepper.value) * -1)
            if floor(paymentView.alreadyPaidStepper.value) == 0 {
                editAddanotherView.descriptionLabel.text = "This loan has just entered repayments.  No payments have been made yet."}
            else if floor(paymentView.alreadyPaidStepper.value) == 0 {
                editAddanotherView.descriptionLabel.text = "This loan has just entered repayments.  One payment has been made so far"}
            else {
                  editAddanotherView.descriptionLabel.text = "This loan is already in repayment. So far \(Int(paymentView.alreadyPaidStepper.value)) payments have been made so far"
            }
        case 1:
           let pickerMonth = paymentView.pickerData[0][paymentView.pickerOutlet.selectedRowInComponent(0)]
           let pickerYear = paymentView.pickerData[1][paymentView.pickerOutlet.selectedRowInComponent(1)]
            firstLoan.monthsUntilRepayment = firstLoan.getMonthsUntilRepayment(pickerMonth, year:pickerYear)
            editAddanotherView.descriptionLabel.text = "This loan will enter repayment in \(pickerMonth) \(pickerYear)"
        default:
            break;}
        var error: NSError?
            if !managedObjectContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func graphFlippedAroundNotVisibleDeleteLoan(){
        var error: NSError?
        //firstLoan.deleteLoanFromDefaultScenario(managedObjectContext)
        if selectedLoan != nil {
            managedObjectContext.deleteObject(selectedLoan! as NSManagedObject)
        }
        
        else {
            managedObjectContext.deleteObject(firstLoan as NSManagedObject)
        }
        if !managedObjectContext.save(&error) {
            println("could not save: \(error)")
        }
    }
}
