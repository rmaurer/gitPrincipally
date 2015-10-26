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
    //Scenario data
    var name : String = ""
    var repaymentType : String = ""
    var frequencyOfExtraPayments : Int!
    var amountOfExtraPayments : Double!
    var interestRateOnRefi : Double!
    var variableInterestRate : Bool = false
    var changeInInterestRate : Double! // this one will need enum to describe options
    var AGI : Double!
    var annualSalaryIncrease : Double!
    var familySize : Int!
    var qualifyingJob : Bool = false
    var IBRDateOptions : Bool = false
    var ICRReqs:Bool = false
    var PAYEReqs:Bool = false
    var refiTerm:Int!
    var yearsInProgram: Double!
    var oneTimePayoff: Double!
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
   // var selectedScenario: Scenario!
    var currentScenario: Scenario!

    
    @IBOutlet weak var nameLabelOutlet: UILabel!
    //global Loan variable

    @IBOutlet weak var graphOfScenario: GraphOfScenario!

    //graph view
    
    @IBOutlet weak var loanDateSliderOutlet: UISlider!
    
    @IBAction func loanDateSliderAction(sender: UISlider) {
        sender.value = floor(sender.value)
        let concatPayment = currentScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        let totalMonths = concatPayment.count - 1
        
        //
        
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveLinear, animations: {
            var graphLineFrame = self.graphLine.frame
            var totalWidth = self.graphOfScenario.frame.width
            var widthRatio = sender.value / sender.maximumValue
            graphLineFrame.origin.x = CGFloat(widthRatio) * totalWidth
            self.graphLine.frame = graphLineFrame
            
            }, completion: nil)
        println(graphLine.frame.origin.x)
        //graphOfEnteredLoan.CAWhiteLine.timeOffset = CFTimeInterval(sender.value / totalMonths)
        
        var currentPayment = concatPayment[Int(sender.value)] as! MonthlyPayment
        
        let mpInterest = round(currentPayment.interest.floatValue * 100) / 100
        let mpPrincipal = round(currentPayment.principal.floatValue * 100) / 100
        let mpTotal = round(currentPayment.totalPayment.floatValue * 100) / 100
        
        principleLabel.text = "$\(mpPrincipal)"
        interestLabel.text = "$\(mpInterest)"
        totalLabel.text = "$\(mpTotal)"
        
        
        var monthAndYear = currentScenario.getStringOfYearAndMonthForPaymentNumber(Double(sender.value))
        paymentDateLabel.text = "Payment for \(monthAndYear)"
        
    }
    
    @IBOutlet weak var graphLine: UIView!
    
    @IBOutlet weak var paymentDateLabel: UILabel!
    
    @IBOutlet weak var principleLabel: UILabel!

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("graphView viewdidload was run") 
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scenario_WindUpForGraph() -> Bool {
        let entity = NSEntityDescription.entityForName("Scenario", inManagedObjectContext: managedObjectContext)
        //set variable of what will be inserted into the entity "Loan"
        currentScenario = Scenario(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        currentScenario.name = name
        currentScenario.repaymentType = repaymentType
        var error: NSError?
        var wasTheScenarioCreated: Bool = false
        //currentScenario.description as String = "You are repaying your loans under the \(repaymentType) plan"
        //have it return whehter it successfully wound up the scenario
        
        switch currentScenario.repaymentType  {
        case "Standard":
            if amountOfExtraPayments == -1 {
                println("there was an error and nothing should be run")
                wasTheScenarioCreated = false
            }
            else if frequencyOfExtraPayments == 0 {
                println("no extra payments")
                currentScenario.standardFlat_WindUp(managedObjectContext, paymentTerm:120)
                wasTheScenarioCreated = true
            }
            else {
                println("yes, extra payments")
                currentScenario.standardFlatExtraPayment_WindUp(managedObjectContext, extra:amountOfExtraPayments, MWEPTotal: frequencyOfExtraPayments, paymentTerm:120)
                println(currentScenario.scenarioDescription)
                wasTheScenarioCreated = true
            }

        case "Extended":
            if amountOfExtraPayments == -1 {
                println("there was an error and nothing should be run")
                        return false
                    }
            else if frequencyOfExtraPayments == 0 {
                println("no extra payments")
                currentScenario.standardFlat_WindUp(managedObjectContext, paymentTerm:300)
                    wasTheScenarioCreated = true
            }
            else {
                println("yes, extra payments")
                currentScenario.standardFlatExtraPayment_WindUp(managedObjectContext, extra:amountOfExtraPayments, MWEPTotal: frequencyOfExtraPayments, paymentTerm:300)
                println(currentScenario.scenarioDescription)
                wasTheScenarioCreated = true

            }
        case "Extended Graduated":
            wasTheScenarioCreated = false
            //no longer doing this 
        case "Standard Graduated":
            wasTheScenarioCreated = false
            //no longer doing this
        case "Refi":
            println("refi")
            if interestRateOnRefi == -1 || oneTimePayoff == -1 {
                println("there was an error in loading interest and nothing should be fun. Variable bool, increase in interest, and refinance term are switch calculations so should not through an error")
                wasTheScenarioCreated = false
            }
            
            else{
                currentScenario.refinance_WindUp(managedObjectContext, interest:interestRateOnRefi, variableBool:variableInterestRate, increaseInInterest:changeInInterestRate, refinanceTerm: refiTerm, oneTimePayoff: oneTimePayoff)
                wasTheScenarioCreated = true
            }
        case "IBR":
            wasTheScenarioCreated = false
        case "ICR":
            wasTheScenarioCreated = false
        case "PAYE":
            if PAYEReqs == false {
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "Unfortunately, you only qualify for PAYE if you meet the date eligibility requirements.  However, see if you qualify for other income-driven repayment plans"
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else if currentScenario.getAllPAYEEligibleLoansPayment() < currentScenario.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "The payments on your PAYE-eligible loans do not exceed 10% of your discretionary income, as required to enter the PAYE plan.  However, some non-eligible loans can be consolidated into loans that would qualify.  Currently this estimator does not handle consolidated loans, but you can talk to your servicer about options, or read more online at the Department of Education's website"
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else {
                currentScenario.PAYE_WindUp(managedObjectContext, AGI:AGI, familySize:familySize, percentageincrease:annualSalaryIncrease)
             wasTheScenarioCreated = true
            }
            
            //if yes, wind up PAYE
        case "IBR with PILF":
            wasTheScenarioCreated = false
        case "ICR with PILF":
            wasTheScenarioCreated = false
        case "PAYE with PILF":
            wasTheScenarioCreated = false
        default:
            wasTheScenarioCreated = false
        }
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")}
        return wasTheScenarioCreated
    }
    
    
    func scenario_makeGraphVisibleWithWoundUpScenario() {
        //graph loan name to set here
        nameLabelOutlet.text = currentScenario.name
        
        //set the Scenario
        graphOfScenario.graphedScenario = currentScenario
        graphOfScenario.setNeedsDisplay()
        
        //tee up the slider
        let concatPayment = currentScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        let totalMonths = concatPayment.count - 1
        
        loanDateSliderOutlet.maximumValue = Float(totalMonths)
        loanDateSliderOutlet.setValue(0, animated: true)
        
        var currentPayment = concatPayment[0] as! MonthlyPayment
        
        let mpInterest = round(currentPayment.interest.floatValue * 100) / 100
        let mpPrincipal = round(currentPayment.principal.floatValue * 100) / 100
        let mpTotal = round(currentPayment.totalPayment.floatValue * 100) / 100
        
        principleLabel.text = "$\(mpPrincipal)"
        interestLabel.text = "$\(mpInterest)"
        totalLabel.text = "$\(mpTotal)"
        
        var monthAndYear = currentScenario.getStringOfYearAndMonthForPaymentNumber(0)
        paymentDateLabel.text = "Payment for \(monthAndYear)"

    }
    
    func scenario_UserWantsToEditAgain(){
        //we've got to delete the scenario from the list
        currentScenario.scenario_DeleteAssociatedObjectsFromManagedObjectContext(managedObjectContext)
        managedObjectContext.deleteObject(currentScenario as NSManagedObject)
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("could not save: \(error)")
        }
        
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
