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
    func scenario_WindUpForGraph() {
        let entity = NSEntityDescription.entityForName("Scenario", inManagedObjectContext: managedObjectContext)
        //set variable of what will be inserted into the entity "Loan"
        currentScenario = Scenario(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        currentScenario.name = name
        currentScenario.repaymentType = repaymentType
        //currentScenario.description as String = "You are repaying your loans under the \(repaymentType) plan"
        
        
        switch currentScenario.repaymentType  {
        case "Default":
            //Todo: This should be deleted.  Will no longer have default entry
            //currentScenario.makeNewExtraPaymentScenario(managedObjectContext, extra:amountOfExtraPayments, MWEPTotal: frequencyOfExtraPayments)
            var test  = 0
        case "Standard":
            
            if frequencyOfExtraPayments == 0 {
                println("no extra payments")
                currentScenario.standardFlat_WindUp(managedObjectContext)
            }
            else {
                println("yes, extra payments")
                currentScenario.standardFlatExtraPayment_WindUp(managedObjectContext, extra:amountOfExtraPayments, MWEPTotal: frequencyOfExtraPayments)
                println(currentScenario.scenarioDescription)
                
            }

        case "Standard Graduated":
            var test = 0
            //no longer doing this
        case "Extended":
            var test = 0
        case "Extended Graduated":
            var test = 0
        case "Default":
            var test = 0
        case "Refi":
            var test = 0
        case "IBR":
            var test = 0
        case "ICR":
            var test = 0
        case "PAYE":
            var test = 0
        case "IBR with PILF":
            var test = 0
        case "ICR with PILF":
            var test = 0
        case "PAYE with PILF":
            var test = 0
        default:
            var test = 0
        }
    
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
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
