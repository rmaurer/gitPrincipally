//
//  LoanEntryViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 5/17/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

protocol TypeViewDelegate{
    func chooseTypeDidFinish(type:String)
}

class LoanEntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, TypeViewDelegate {
    
//MARK: CoreData MOC
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    
//MARK: UI Buttons

    
    //Name / Balance / interest
    @IBOutlet weak var newName:UITextField! = UITextField()

    //TODO: programmatically set the number name with some incredmental counter?

    //Loan type and delegate stuff -- TypeModalVC
    @IBOutlet weak var loanTypeButton: UIButton!
    
        let loanVC = TypeModalVC(nibName: "TypeModalVC", bundle: nil)
    
        @IBAction func loanTypeButtonPressed(sender: UIButton) {
            loanVC.delegate = self
            loanVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            presentViewController(loanVC, animated: true, completion: nil)
        }
    
        func chooseTypeDidFinish(type:String){
            self.loanTypeButton.setTitle(type, forState: .Normal)
        }
    
    @IBOutlet weak var balance:UITextField! = UITextField()
    
    @IBOutlet weak var interest:UITextField! = UITextField()

    //Segment 1 - paymentPicker
    
    @IBOutlet weak var paymentStartPicker: UIPickerView!
    
    //Segment 2 - monthly payment
    
    
    
    @IBOutlet weak var perMonth: UILabel!
    
    @IBOutlet weak var monthlyPaymentAmount: UITextField!

    @IBOutlet weak var segmentedEntryViewOutlet: UISegmentedControl!
    
    @IBOutlet weak var termSliderContainer: UIView!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var startingLabel: UILabel!
    @IBOutlet weak var termSliderLabel: UILabel!
    
    @IBAction func segmentedEntryView(sender: UISegmentedControl) {
        self.view.endEditing(true)
        switch sender.selectedSegmentIndex {
        case 0:
            //dollarSign.hidden = true
            monthlyPaymentAmount.hidden = true
            perMonth.hidden = true
            paymentStartPicker.hidden = false
            termSliderOutlet.hidden = false
            termLabel.hidden = false
            termSliderLabel.hidden = false
            termSliderContainer.hidden = false
            startingLabel.hidden = false
        case 1:
            //dollarSign.hidden = false
            monthlyPaymentAmount.hidden = false
            perMonth.hidden = false
            paymentStartPicker.hidden = true
            termSliderOutlet.hidden = true
            termLabel.hidden = true
            termSliderContainer.hidden = true
            termSliderLabel.hidden = true
            startingLabel.hidden = true
        default:
            break;
        }
        
    }
    
    @IBOutlet weak var termSliderOutlet: UISlider!
    
    @IBAction func termSlider(sender: UISlider) {
        var sliderByFives = Int(sender.value/5) * 5
        sender.value = Float(sliderByFives)
        termSliderLabel.text = "\(sliderByFives) years"
    }
    
    
    @IBAction func EnteredNewLoan(sender: UIBarButtonItem) {
        GlobalLoanCount.sharedGlobalLoanCount.count = GlobalLoanCount.sharedGlobalLoanCount.count + 1
        //resign first responders
        self.newName.resignFirstResponder()
        self.balance.resignFirstResponder()
        self.interest.resignFirstResponder()
        
        //pull names from the Outlets
        var name = newName.text
        
        //TODO: do some validating -- make sure these are strings and numbers
        var loanBalance = NSNumberFormatter().numberFromString(balance.text)!
        var loanInterest = NSNumberFormatter().numberFromString(interest.text)!
        
        //pull entity within the managedObjectContext of "loan"
        let entity = NSEntityDescription.entityForName("Loan", inManagedObjectContext: managedObjectContext)
        //set variable of what will be inserted into the entity "Loan"
        let firstLoan = Loan(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        //Set the characteristics of what will be added
        firstLoan.name = name as String
        firstLoan.balance = loanBalance as NSNumber
        firstLoan.interest = loanInterest as NSNumber
        firstLoan.loanType = loanTypeButton.currentTitle!
        
        switch segmentedEntryViewOutlet.selectedSegmentIndex {
        case 0:
            //start date picker
            //Got to calculate months until repayment.  Set the loans month
            let month = pickerData[0][paymentStartPicker.selectedRowInComponent(0)]
            let year = pickerData[1][paymentStartPicker.selectedRowInComponent(1)]
            firstLoan.monthsInRepaymentTerm = Int(termSliderOutlet.value) * 12
            firstLoan.monthsUntilRepayment = firstLoan.getMonthsUntilRepayment(month, year:year)
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
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        case 1:
            //using monthly payment
             var payment = NSNumberFormatter().numberFromString(monthlyPaymentAmount.text)!
            firstLoan.defaultMonthlyPayment = payment
            firstLoan.enteredLoanByPayment(managedObjectContext)
            var error: NSError?
            if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            }
            self.navigationController?.popToRootViewControllerAnimated(true)
        default:
            break;
        }
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //more delegate bullshit for the picker
        paymentStartPicker.dataSource = self
        paymentStartPicker.delegate = self
        paymentStartPicker.selectRow(1, inComponent: 0, animated: true)
        paymentStartPicker.selectRow(25, inComponent: 1, animated: true)
        
        //ensure that at the beginning the monthly payment amount is hidden
        //dollarSign.hidden = true
        monthlyPaymentAmount.hidden = true
        perMonth.hidden = true
        
        // Do any additional setup after loading the view.
        newName.text = "Loan #" + String(GlobalLoanCount.sharedGlobalLoanCount.count)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //resign the first responder when you touch elsewhere on the screen
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    //MARK: - Picker Delegates and data sources
    //MARK: Data Sources
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
