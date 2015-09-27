//
//  TestLoanEntryViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/26/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData


class TestLoanEntryViewController: UIViewController,UITextFieldDelegate, TypeViewDelegate  {
    //BalanceInterestDelgate
    
    //Flipping view when loan is entered
    
    var loanIsEnteredGraphIsShowing : Bool = false

    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var entryContainer: UIView!
    
    @IBAction func doneButton(sender: UIBarButtonItem) {

        
        //grab each of the views that we're going to need
        let BIView = self.childViewControllers[0] as! BalanceInterestTableViewController
        let paymentView = self.childViewControllers[2] as! PaymentContainerTableViewController
        let graphView = self.childViewControllers[1] as! GraphViewController
        println(graphView.testLabel1.text)
        
        
        //resign first responders
        
        self.loanNameOutlet.resignFirstResponder()
        BIView.interest.resignFirstResponder()
        BIView.balance.resignFirstResponder()
        
        
        
        if loanIsEnteredGraphIsShowing {
            UIView.transitionFromView(graphContainer,
                toView: entryContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "Done"
            selectLoantype.enabled = true
            BIView.interest.userInteractionEnabled = true
            BIView.balance.userInteractionEnabled = true
            loanNameOutlet.userInteractionEnabled = true
            loanIsEnteredGraphIsShowing = !loanIsEnteredGraphIsShowing
        }
        else {
        //the person is entering the loan, so switch the button to editing
        //first, we load up the graph container view with the information we need
            graphView.interest = getNSNumberFromString(BIView.interest.text)
            graphView.balance = getNSNumberFromString(BIView.balance.text)
            graphView.name = getLoanName()
            graphView.type = getLoanType()
            graphView.segmentedEntryType = paymentView.segmentedOutlet.selectedSegmentIndex
            graphView.pickerMonth = paymentView.pickerData[0][paymentView.pickerOutlet.selectedRowInComponent(0)]
            graphView.pickerYear = paymentView.pickerData[1][paymentView.pickerOutlet.selectedRowInComponent(1)]
            graphView.sliderTerm = Int(paymentView.termSlider.value) * 12
            graphView.monthlyAmount = getNSNumberFromString(paymentView.monthlyAmountTextField.text)
            
            
            //Just making sure there isn't an error in the interest/balance inputs.  Granted, this is super messy, but it works for now
            if graphView.interest != -1 && graphView.balance != -1 && graphView.type != "Select Loan Type" && graphView.name != "Loan Name"{
                
                
            //load up the new information in the graph View
                graphView.graphFlippedAroundVisible()
            
                UIView.transitionFromView(entryContainer,
                    toView: graphContainer,
                    duration: 1.0,
                    options: UIViewAnimationOptions.TransitionFlipFromRight
                        | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
                sender.title = "Edit"
                selectLoantype.enabled = false
                BIView.interest.userInteractionEnabled = false
                BIView.balance.userInteractionEnabled = false
                loanNameOutlet.userInteractionEnabled = false
                loanIsEnteredGraphIsShowing = !loanIsEnteredGraphIsShowing
            }
            
        }
    
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
}
