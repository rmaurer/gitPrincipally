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
    var yearsInProgram: Int!
    var oneTimePayoff: Double!
    var headOfHousehold:Bool = false
    
    
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
   // var selectedScenario: Scenario!
    var currentScenario: Scenario!

    @IBOutlet weak var principalSoFarLabel: UILabel!
    
    @IBOutlet weak var interestSoFarLabel: UILabel!
    
    @IBOutlet weak var textDescriptionTextViewOutlet: UITextView!

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
        //println(graphLine.frame.origin.x)
        //graphOfEnteredLoan.CAWhiteLine.timeOffset = CFTimeInterval(sender.value / totalMonths)
        
        var currentPayment = concatPayment[Int(sender.value)] as! MonthlyPayment
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        
        numberFormatter.stringFromNumber(currentPayment.interest)
        
        let mpInterest = numberFormatter.stringFromNumber(currentPayment.interest)!//round(currentPayment.interest.floatValue * 100) / 100
        let mpPrincipal = numberFormatter.stringFromNumber(currentPayment.principal)!//round(currentPayment.principal.floatValue * 100) / 100
        let mpTotal = numberFormatter.stringFromNumber(currentPayment.totalPayment)!//round(currentPayment.totalPayment.floatValue * 100) / 100
        let mpPrincipalSoFar = numberFormatter.stringFromNumber(currentPayment.totalPrincipalSoFar)!//round(currentPayment.totalPrincipalSoFar.floatValue * 100) / 100
        let mpInterestSoFar = numberFormatter.stringFromNumber(currentPayment.totalInterestSoFar)!//round(currentPayment.totalInterestSoFar.floatValue * 100) / 100
        
        principleLabel.text = "\(mpPrincipal)"
        interestLabel.text = "\(mpInterest)"
        totalLabel.text = "\(mpTotal)"
        principalSoFarLabel.text = "\(mpPrincipalSoFar)"
        interestSoFarLabel.text = "\(mpInterestSoFar)"
        
        var monthAndYear = currentScenario.getStringOfYearAndMonthForPaymentNumber(Double(sender.value))
        
        //nameLabelOutlet.text = "In \(monthAndYear), you will make a payment of \(mpTotal).  \(mpPrincipal) will go towards principal, and \(mpInterest) will pay off interest.  At this point you'll have paid off \(mpPrincipalSoFar), and will have paid \(mpInterestSoFar) in interst so far"
        
        paymentDateLabel.text = "Payment for \(monthAndYear)"
        
    }
    
    @IBOutlet weak var graphLine: UIView!
    
    @IBOutlet weak var paymentDateLabel: UILabel!
    
    @IBOutlet weak var principleLabel: UILabel!

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println("graphView viewdidload was run")
        
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
                //println(currentScenario.scenarioDescription)
                wasTheScenarioCreated = true
            }

        case "Extended":
            if amountOfExtraPayments == -1 {
                println("there was an error and nothing should be run")
                        return false
                    }
            else if currentScenario.getEligibleExtendedBalance() {
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "You need to have at least $30,000 in eligible loans to be able to enter the extended repayment plan"
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else if frequencyOfExtraPayments == 0 {
                println("no extra payments")
                currentScenario.standardFlatExtendedWindUp(managedObjectContext, paymentTerm:300)
                    wasTheScenarioCreated = true
            }
            else {
                println("yes, extra payments")
                currentScenario.standardFlatExtraPayment_WindUp(managedObjectContext, extra:amountOfExtraPayments, MWEPTotal: frequencyOfExtraPayments, paymentTerm:300)
                //println(currentScenario.scenarioDescription)
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
                //println("there was an error in loading interest and nothing should be fun. Variable bool, increase in interest, and refinance term are switch calculations so should not through an error")
                wasTheScenarioCreated = false
            }
            
            else{
                currentScenario.refinance_WindUp(managedObjectContext, interest:interestRateOnRefi, variableBool:variableInterestRate, increaseInInterest:changeInInterestRate, refinanceTerm: refiTerm, oneTimePayoff: oneTimePayoff)
                wasTheScenarioCreated = true
            }
        case "ICR":
            currentScenario.ICR_PSLF_or_Standard_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease, headOfHousehold:headOfHousehold, term:25)
            wasTheScenarioCreated = true
        case "IBR":
            if IBRDateOptions  {
                //new borrower
                //first test if the standard loan payments is less than 10% of your discretionary income
                if currentScenario.getAllEligibleLoansPayment(true, isPSLF:false).monthly < currentScenario.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                    wasTheScenarioCreated = false
                    let alert = UIAlertView()
                    alert.title = "Cannot Create Plan"
                    alert.message = "The payments on your IBR-eligible loans do not exceed 10% of your discretionary income, as required to enter the IBR plan."
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else{
                    currentScenario.IBR_Standard_Or_PSLF_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease, term:20, newBorrower:true)
                    wasTheScenarioCreated = true
                }
            }
            else {
                //old borrower
                if currentScenario.getAllEligibleLoansPayment(true, isPSLF:false).monthly < currentScenario.percentageOfDiscretionaryIncome(15, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                    wasTheScenarioCreated = false
                    let alert = UIAlertView()
                    alert.title = "Cannot Create Plan"
                    alert.message = "The payments on your IBR-eligible loans do not exceed 15% of your discretionary income, as required to enter the IBR plan."
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else {
                    currentScenario.IBR_Standard_Or_PSLF_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease, term:25, newBorrower:false)
                    wasTheScenarioCreated = true
                }
            }
            
        case "PAYE":
            if PAYEReqs == false {
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "You only qualify for PAYE if you meet the date eligibility requirements."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else if currentScenario.getAllEligibleLoansPayment(false, isPSLF:false).monthly < currentScenario.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "The payments on your PAYE-eligible loans do not exceed 10% of your discretionary income, as required to enter the PAYE plan."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else {
                currentScenario.PAYE_Standard_Or_PSLF_Wrapper(managedObjectContext, AGI:AGI, familySize:familySize, percentageincrease:annualSalaryIncrease, term:20)
             wasTheScenarioCreated = true
            }
            
            //if yes, wind up PAYE
        case "IBR with PSLF":
            if qualifyingJob == false {
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "You are only eligible for Public Service Loan Forgiveness if you have a qualifying public interest job."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else if IBRDateOptions  {
                //new borrower
                //first test if the standard loan payments is less than 10% of your discretionary income
                if currentScenario.getAllEligibleLoansPayment(true, isPSLF:true).monthly < currentScenario.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                    wasTheScenarioCreated = false
                    let alert = UIAlertView()
                    alert.title = "Cannot Create Plan"
                    alert.message = "The payments on your IBR-eligible loans do not exceed 10% of your discretionary income, as required to enter the IBR plan."
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else{
                    currentScenario.IBR_Standard_Or_PSLF_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease, term:10, newBorrower:true)
                    wasTheScenarioCreated = true
                }
            }
            else {
                //old borrower
                if currentScenario.getAllEligibleLoansPayment(true, isPSLF:true).monthly < currentScenario.percentageOfDiscretionaryIncome(15, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                    wasTheScenarioCreated = false
                    let alert = UIAlertView()
                    alert.title = "Cannot Create Plan"
                    alert.message = "The payments on your IBR-eligible loans do not exceed 15% of your discretionary income, as required to enter the IBR plan."
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else {
                    currentScenario.IBR_Standard_Or_PSLF_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease, term:10, newBorrower:false)
                    wasTheScenarioCreated = true
                }
            }

        case "ICR with PSLF":
            if qualifyingJob == false {
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "You are only eligible for Public Service Loan Forgiveness if you have a qualifying public interest job."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else {
                currentScenario.ICR_PSLF_or_Standard_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease, headOfHousehold:headOfHousehold, term:10)
                wasTheScenarioCreated = true
            }
        case "PAYE with PSLF":
            if qualifyingJob == false {
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "You are only eligible for Public Service Loan Forgiveness if you have a qualifying public interest job."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else if PAYEReqs == false {
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = "You only qualify for PAYE if you meet the date eligibility requirements."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else if currentScenario.getAllEligibleLoansPayment(false, isPSLF:true).monthly < currentScenario.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "The payments on your PAYE-eligible loans do not exceed 10% of your discretionary income, as required to enter the PAYE plan."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else {
                currentScenario.PAYE_Standard_Or_PSLF_Wrapper(managedObjectContext, AGI:AGI, familySize:familySize, percentageincrease:annualSalaryIncrease, term:10)
                wasTheScenarioCreated = true
            }
        case "IBR Limited":
            if IBRDateOptions  {
                //new borrower
                //first test if the standard loan payments is less than 10% of your discretionary income
                if currentScenario.getAllEligibleLoansPayment(true, isPSLF:false).monthly < currentScenario.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                    wasTheScenarioCreated = false
                    let alert = UIAlertView()
                    alert.title = "Cannot Create Plan"
                    alert.message = "The payments on your IBR-eligible loans do not exceed 10% of your discretionary income, as required to enter the IBR plan."
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else{
                    currentScenario.IBR_LimitedTerm_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease,yearsInProgram:yearsInProgram, newBorrower:true)
                    wasTheScenarioCreated = true
                }
            }
            else {
                //old borrower
                if currentScenario.getAllEligibleLoansPayment(true, isPSLF:false).monthly < currentScenario.percentageOfDiscretionaryIncome(15, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                    wasTheScenarioCreated = false
                    let alert = UIAlertView()
                    alert.title = "Cannot Create Plan"
                    alert.message = "The payments on your IBR-eligible loans do not exceed 15% of your discretionary income, as required to enter the IBR plan."
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else {
                    currentScenario.IBR_LimitedTerm_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease,yearsInProgram:yearsInProgram, newBorrower:false)
                    wasTheScenarioCreated = true
                }
            }
        case "PAYE Limited":
            if PAYEReqs == false {
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "You only qualify for PAYE if you meet the date eligibility requirements."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else if currentScenario.getAllEligibleLoansPayment(false, isPSLF:false).monthly < currentScenario.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:0, increase:annualSalaryIncrease){
                wasTheScenarioCreated = false
                let alert = UIAlertView()
                alert.title = "Cannot Create Plan"
                alert.message = "The payments on your PAYE-eligible loans do not exceed 10% of your discretionary income, as required to enter the PAYE plan."
                alert.addButtonWithTitle("Understood")
                alert.show()
            }
            else {
                currentScenario.PAYE_LimitedTerm_Wrapper(managedObjectContext, AGI:AGI, familySize:familySize, percentageincrease:annualSalaryIncrease, yearsInProgram:yearsInProgram)
                wasTheScenarioCreated = true
            }

        case "ICR Limited":
            currentScenario.ICR_LimitedTerm_Wrapper(managedObjectContext, AGI: AGI, familySize: familySize, percentageincrease: annualSalaryIncrease, headOfHousehold:headOfHousehold, term:yearsInProgram)
            wasTheScenarioCreated = true
        default:
            wasTheScenarioCreated = false
        }
        
        if wasTheScenarioCreated{
            currentScenario.addTotalInterestAndPrincipalSoFarToConcatPayment(managedObjectContext)
            self.saveScenarioSettings()
            currentScenario.scenarioDescription = currentScenario.settings.createDescription()
            currentScenario.generateRandomButConstantColor(managedObjectContext)
        }
        
        
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")}
        return wasTheScenarioCreated
    }
    
    func saveScenarioSettings(){
        
        let entity = NSEntityDescription.entityForName("ScenarioSettings", inManagedObjectContext: managedObjectContext)
        var error: NSError?
        var settings = ScenarioSettings(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        
        settings.repaymentType = repaymentType
        settings.frequencyOfExtraPayments = frequencyOfExtraPayments
        settings.amountOfExtraPayments = amountOfExtraPayments
        settings.interestRateOnRefi = interestRateOnRefi
        settings.variableInterestRate = variableInterestRate
        settings.changeInInterestRate = changeInInterestRate // this one will need enum to describe options
        settings.agi = AGI
        settings.annualSalaryIncrease = annualSalaryIncrease
        settings.familySize = familySize
        settings.qualifyingJob = qualifyingJob
        settings.ibrDateOptions = IBRDateOptions
        settings.icrReqs = ICRReqs
        settings.payeReqs = PAYEReqs
        settings.refiTerm = refiTerm
        settings.yearsInProgram = yearsInProgram
        settings.oneTimePayoff = oneTimePayoff
        settings.headOfHousehold = headOfHousehold
        
        currentScenario.settings = settings
        
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        println("got past saving")
        
    }
    
    
    func scenario_makeGraphVisibleWithWoundUpScenario() {
        //graph loan name to set here
        
        //set the Scenario
        graphOfScenario.graphedScenario = currentScenario
        graphOfScenario.setNeedsDisplay()
        
        //tee up the slider
        let concatPayment = currentScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        let totalMonths = concatPayment.count - 1
        
        loanDateSliderOutlet.maximumValue = Float(totalMonths)
        loanDateSliderOutlet.setValue(0, animated: true)
        
        var currentPayment = concatPayment[0] as! MonthlyPayment
        
       // let mpInterest = round(currentPayment.interest.floatValue * 100) / 100
       // let mpPrincipal = round(currentPayment.principal.floatValue * 100) / 100
       // let mpTotal = round(currentPayment.totalPayment.floatValue * 100) / 100
       // let mpPrincipalSoFar = round(currentPayment.totalPrincipalSoFar.floatValue * 100) / 100
       // let mpInterestSoFar = round(currentPayment.totalInterestSoFar.floatValue * 100) / 100

        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        
        numberFormatter.stringFromNumber(currentPayment.interest)
        
        let mpInterest = numberFormatter.stringFromNumber(currentPayment.interest)!//round(currentPayment.interest.floatValue * 100) / 100
        let mpPrincipal = numberFormatter.stringFromNumber(currentPayment.principal)!//round(currentPayment.principal.floatValue * 100) / 100
        let mpTotal = numberFormatter.stringFromNumber(currentPayment.totalPayment)!//round(currentPayment.totalPayment.floatValue * 100) / 100
        let mpPrincipalSoFar = numberFormatter.stringFromNumber(currentPayment.totalPrincipalSoFar)!//round(currentPayment.totalPrincipalSoFar.floatValue * 100) / 100
        let mpInterestSoFar = numberFormatter.stringFromNumber(currentPayment.totalInterestSoFar)!//round(currentPayment.totalInterestSoFar.floatValue * 100) / 100
        
        
        
        
        principleLabel.text = "\(mpPrincipal)"
        interestLabel.text = "\(mpInterest)"
        totalLabel.text = "\(mpTotal)"
        principalSoFarLabel.text = "\(mpPrincipalSoFar)"
        interestSoFarLabel.text = "\(mpInterestSoFar)"
        
        textDescriptionTextViewOutlet.text = currentScenario.scenarioDescription
        textDescriptionTextViewOutlet.scrollRangeToVisible(NSMakeRange(0, 0))
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
