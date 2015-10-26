//
//  Scenario.swift
//  
//
//  Created by Rebecca Maurer on 5/31/15.
//
/*
//LOAN
@NSManaged var balance: NSNumber
@NSManaged var interest: NSNumber
@NSManaged var name: String
@NSManaged var repaymentStart: NSDate
@NSManaged var loanType: String
@NSManaged var defaultMonthlyPayment: NSNumber
//@NSManaged var defaultScenario: AnyObject
@NSManaged var mpForOneLoan: NSOrderedSet
@NSManaged var thisLoansScenario: Scenario
@NSManaged var monthsInRepaymentTerm: NSNumber
@NSManaged var monthsUntilRepayment: NSNumber

//Monthlypayment
@NSManaged var principal: NSNumber
@NSManaged var interest: NSNumber
@NSManaged var totalPayment: NSNumber
@NSManaged var paymentIndex: NSNumber
@NSManaged var loans: Loan
@NSManaged var paymentConcatScenario: NSManagedObject 
*/

//

import Foundation
import CoreData

class Payment_NotCoreData {
    var interest:Double = 0.0
    var principal:Double = 0.0
    var total:Double = 0.0
}

class Scenario: NSManagedObject {

    @NSManaged var interestOverLife: NSNumber
    @NSManaged var timeToRepay: NSDate
    @NSManaged var scenarioDescription: String
    @NSManaged var name: String
    @NSManaged var allLoans: NSOrderedSet
    @NSManaged var concatenatedPayment: NSOrderedSet
    @NSManaged var defaultTotalScenarioInterest: NSNumber
    @NSManaged var defaultTotalScenarioMonths: NSNumber
    @NSManaged var nnewTotalScenarioInterest: NSNumber
    @NSManaged var nnewTotalScenarioMonths: NSNumber
    @NSManaged var defaultScenarioMaxPayment: NSNumber
    @NSManaged var nnewScenarioMaxPayment: NSNumber
    @NSManaged var repaymentType : String
    
    func standardFlat_WindUp(managedObjectContext:NSManagedObjectContext, paymentTerm:Int) {
    
        //initialize things
        self.interestOverLife = 0
        self.nnewScenarioMaxPayment = 0
        self.nnewTotalScenarioInterest = 0
        self.nnewTotalScenarioMonths = 0
        
        //get all the loans as objects
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            lArray.append(oldLoan)
        }
        
        lArray.sort {$0.interest.doubleValue > $1.interest.doubleValue}
        
        for loan in lArray{
            self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(paymentTerm))
        }
        
        
    }
    
    func getAllPAYEEligibleLoansPayment() -> Double {
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var cumulativePayment : Double = 0
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            if oldLoan.loanType == "Direct, Subs." || oldLoan.loanType == "Direct, Unsubs."  || oldLoan.loanType == "Grad PLUS" {
                cumulativePayment += oldLoan.getStandardMonthlyPayment(120, balance: oldLoan.balance.doubleValue)
            }
        }
        return cumulativePayment
        
    }
    
    func PAYE_WindUp(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var cumulativeBalance_Unsubs : Double = 0
        var weightedInterest_Unsubs : Double = 0
        var cumulativeBalance_AllLoans : Double = 0
        var weightedInterest_AllLoans : Double = 0
        var cumulativeBalance_Subs : Double = 0
        var weightedInterest_Subs : Double = 0
        var subsidizedLoans = [Loan]()
        var monthsUntilRepayment : Int = 0
        var PAYeligiblepayment = self.getAllPAYEEligibleLoansPayment()
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            lArray.append(oldLoan)
        }
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" {
                cumulativeBalance_Unsubs += loan.balance.doubleValue
                weightedInterest_Unsubs += loan.balance.doubleValue * loan.interest.doubleValue
                cumulativeBalance_AllLoans += loan.balance.doubleValue
                weightedInterest_AllLoans += loan.balance.doubleValue * loan.interest.doubleValue
                //we just want to capture one months until repayment.  ASSUMPTION: all of the direct loans will enter repayment at the same time
                monthsUntilRepayment = loan.monthsUntilRepayment.integerValue
            }
            else if loan.loanType == "Direct, Subs." {
                subsidizedLoans.append(loan)
                cumulativeBalance_Subs += loan.balance.doubleValue
                weightedInterest_Subs += loan.balance.doubleValue * loan.interest.doubleValue
                cumulativeBalance_AllLoans += loan.balance.doubleValue
                weightedInterest_AllLoans += loan.balance.doubleValue * loan.interest.doubleValue
                monthsUntilRepayment = loan.monthsUntilRepayment.integerValue
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        
        if cumulativeBalance_Unsubs != 0 {
            weightedInterest_Unsubs = weightedInterest_Unsubs / cumulativeBalance_Unsubs}
        else {weightedInterest_Unsubs = 0}
        
        if cumulativeBalance_Subs != 0 {
            weightedInterest_Subs = weightedInterest_Subs / cumulativeBalance_Subs
        }
        else {weightedInterest_Subs = 0 }

        weightedInterest_AllLoans = weightedInterest_AllLoans / cumulativeBalance_AllLoans
        
       // let entity = NSEntityDescription.entityForName("Loan", inManagedObjectContext: managedObjectContext)
       // //set variable of what will be inserted into the entity "Loan"
       // var unsubsidizedLoan = Loan(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
       // unsubsidizedLoan.balance = cumulativeBalance_Unsubs
       // unsubsidizedLoan.interest = weightedInterest_Unsubs
       // unsubsidizedLoan.monthsUntilRepayment = monthsUntilRepayment
      //
       // var subsidizedLoan = Loan(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
      //
        //subsidizedLoan.balance = cumulativeBalance_Subs
        //subsidizedLoan.interest = weightedInterest_Subs
        //subsidizedLoan.monthsUntilRepayment = monthsUntilRepayment
        //for each year, we need to test for the payment, and figure out how much interest is accumulating.
        
        var paymentArrayToReturn = [Payment_NotCoreData]()
        
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            paymentArrayToReturn.append(paymentToAdd)
            monthsUntilRepayment -= 1
        }
        
        let rate_weightedInterest_AllLoans = (weightedInterest_AllLoans / 12 ) / 100
        let rate_weightedInterest_Subs = (weightedInterest_Subs / 12 ) / 100
        let rate_weightedInterest_Unsubs = (weightedInterest_Unsubs / 12 ) / 100
        var balance = cumulativeBalance_AllLoans
        var unsubs_balance = cumulativeBalance_Unsubs
        var subs_balance = cumulativeBalance_Subs
        var excessInterest : Double = 0
        var newBalance :Double = balance
        
        println([rate_weightedInterest_AllLoans, rate_weightedInterest_Subs, rate_weightedInterest_Unsubs, balance, unsubs_balance, subs_balance, excessInterest, newBalance])
        
        for year in 1...20{
            let payment = self.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:year, increase:percentageincrease)
            println("the eligible payment is \(payment)")

            if PAYeligiblepayment > payment && year <= 3 {
                for month in 1...12{
                    //println(monthsLeftInTerm)
                    var paymentToAdd = Payment_NotCoreData()
                    //first, split up the balance
                    let payment_applied_to_unsubsidiezed = payment * (cumulativeBalance_Unsubs / cumulativeBalance_AllLoans)
                    let payment_applied_to_subsidiezed = payment * (cumulativeBalance_Subs / cumulativeBalance_AllLoans)//This year is in PAYE and interest does not exist for subsidized loans
                    
                    //next, add the payment on the unsubisidzed loans
                    paymentToAdd.interest = minElement([payment_applied_to_unsubsidiezed, (unsubs_balance * rate_weightedInterest_Unsubs) ])
                    paymentToAdd.principal = payment_applied_to_unsubsidiezed - paymentToAdd.interest
                    paymentToAdd.total = payment_applied_to_unsubsidiezed
                    unsubs_balance = unsubs_balance - paymentToAdd.principal
                    excessInterest += maxElement([0, (paymentToAdd.interest - paymentToAdd.total)])
                    
                    //next add the part of hte payment on the subsiidized loans, but don't add the excess interest
                    //next, add the payment on the unsubisidzed loans
                    paymentToAdd.interest += minElement([payment_applied_to_subsidiezed, (subs_balance * rate_weightedInterest_Subs) ])
                    paymentToAdd.principal += payment_applied_to_subsidiezed - paymentToAdd.interest
                    paymentToAdd.total = payment //+= payment_applied_to_subsidiezed
                    subs_balance = subs_balance - (payment_applied_to_subsidiezed - minElement([payment_applied_to_subsidiezed, (subs_balance * rate_weightedInterest_Subs) ]))
                    println("payment number")
                    println([year,month])
                    println(paymentToAdd)
                    paymentArrayToReturn.append(paymentToAdd)
                }
                newBalance = subs_balance + unsubs_balance + excessInterest
            }
            else if PAYeligiblepayment > payment {
                //this year is in PAYE and interest accrus on all loans, we will never go back to differentiating subsizied and unsubsizied
                for month in 1...12{
                    //println(monthsLeftInTerm)
                    var paymentToAdd = Payment_NotCoreData()
                    //first, split up the balance
                    let payment_applied_to_unsubsidiezed = payment * (cumulativeBalance_Unsubs / cumulativeBalance_AllLoans)
                    let payment_applied_to_subsidiezed = payment * (cumulativeBalance_Subs / cumulativeBalance_AllLoans)//This year is in PAYE and interest does not exist for subsidized loans
                    
                    //next, add the payment on the unsubisidzed loans
                    paymentToAdd.interest = minElement([payment_applied_to_unsubsidiezed, (unsubs_balance * rate_weightedInterest_Unsubs) ])
                    paymentToAdd.principal = payment_applied_to_unsubsidiezed - paymentToAdd.interest
                    paymentToAdd.total = payment_applied_to_unsubsidiezed
                    unsubs_balance = unsubs_balance - paymentToAdd.principal
                    
                    //next add the part of hte payment on the subsiidized loans, but don't add the excess interest
                    //next, add the payment on the unsubisidzed loans
                    paymentToAdd.interest += minElement([payment_applied_to_subsidiezed, (subs_balance * rate_weightedInterest_Subs) ])
                    paymentToAdd.principal += payment_applied_to_subsidiezed - paymentToAdd.interest
                    paymentToAdd.total += payment_applied_to_subsidiezed
                    subs_balance = subs_balance - (payment_applied_to_subsidiezed - minElement([payment_applied_to_subsidiezed, (subs_balance * rate_weightedInterest_Subs) ]))
                    
                    //how we add interest from both loans, including subsidized
                    excessInterest += maxElement([0, (paymentToAdd.interest - paymentToAdd.total)])
                    
                    paymentArrayToReturn.append(paymentToAdd)
                }
                newBalance = subs_balance + unsubs_balance + excessInterest
            }
            else {
                for month in 1...12{
                    if newBalance > PAYeligiblepayment {
                        var paymentToAdd = Payment_NotCoreData()
                        paymentToAdd.interest = rate_weightedInterest_AllLoans * newBalance
                        paymentToAdd.principal = PAYeligiblepayment - paymentToAdd.interest
                        paymentToAdd.total = PAYeligiblepayment
                        newBalance -= paymentToAdd.principal
                        paymentArrayToReturn.append(paymentToAdd)
                    }
                    else {
                        var lastPaymentToAdd = Payment_NotCoreData()
                        lastPaymentToAdd.interest = newBalance * rate_weightedInterest_AllLoans
                        lastPaymentToAdd.principal = newBalance
                        lastPaymentToAdd.total = newBalance + (newBalance * rate_weightedInterest_AllLoans)
                        newBalance = 0
                        paymentArrayToReturn.append(lastPaymentToAdd)
                        break
                    }
                }

        }
        
        //for the first three years,
        //keep track of accumulated interest 
        //ASSUMPTION:
    }
        self.addPaymentsForOneLoan(managedObjectContext, loansPayments:paymentArrayToReturn)
    }
    
    func percentageOfDiscretionaryIncome(percentOfDI: Double, AGI:Double, familySize:Int, year:Int, increase:Double) -> Double {
        println([percentOfDI, AGI, familySize, year, increase])
        //if all eligible laons were on a standard 10-year repayment plan, it would exceed 15 percent of their discretionary income
        //this will return
        //ASSUMPTION: Federal poverty guidelines for 48 continguous states
        let FPG : Double!
        var adjustedGrossIncome : Double = AGI
        switch familySize{
        case 1:
            FPG = 11770
        case 2:
            FPG = 15930
        case 3:
            FPG = 20090
        case 4:
            FPG = 24250
        case 5:
            FPG = 28410
        case 6:
            FPG = 32570
        case 7:
            FPG = 36730
        case 8:
            FPG = 40890
        default:
            FPG = 11770
        }
        
        let OneHundredFiftyPercentOfFPG = FPG * 1.5
        for eachYear in 0...year {
            adjustedGrossIncome = adjustedGrossIncome + adjustedGrossIncome*(increase/100)
        }
        let discretionaryIncome = maxElement([(adjustedGrossIncome - OneHundredFiftyPercentOfFPG), 0])
        let percentOfDiscretionaryIncome = (percentOfDI/100) * discretionaryIncome
        
        return percentOfDiscretionaryIncome
        
    }

    
    func addPaymentsForOneLoan(managedObjectContext:NSManagedObjectContext, loansPayments:[Payment_NotCoreData]){
        let concatPayment = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        var error: NSError?
        
        //make sure there's enough in the concatenated payment
        while concatPayment.count < loansPayments.count {
            var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            monthlyPaymentToBeAdded.interest = 0//balance * rate
            monthlyPaymentToBeAdded.principal = 0//monthlyPayment - (balance * rate)
            monthlyPaymentToBeAdded.totalPayment = 0//monthlyPayment
            concatPayment.addObject(monthlyPaymentToBeAdded)
        }
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        println("got past saving")

        
        for index in 0...loansPayments.count-1{
            let individualLoanPayment = loansPayments[index]
            let scenarioPayment = concatPayment[index] as! MonthlyPayment
            scenarioPayment.addNonCoreDataPaymentToMP(individualLoanPayment)
        }
        
        self.concatenatedPayment = concatPayment.copy() as! NSOrderedSet
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        println("got past saving the last time")
        println(concatPayment.count)
        
    }
    
    
    func getDefault(managedObjectContext:NSManagedObjectContext) -> Scenario {
        let scenarioEntity = NSEntityDescription.entityForName("Scenario", inManagedObjectContext: managedObjectContext)
        let defaultScenarioName = "default"
        var defaultScenario: Scenario!
        let scenarioFetch = NSFetchRequest(entityName: "Scenario")
        scenarioFetch.predicate = NSPredicate(format: "name == %@", defaultScenarioName)
        var error: NSError?
        let result = managedObjectContext.executeFetchRequest(scenarioFetch, error: &error) as! [Scenario]?
        
        if let allScenarios = result {
            if allScenarios.count == 0 {
                defaultScenario = Scenario(entity: scenarioEntity!, insertIntoManagedObjectContext: managedObjectContext)
                defaultScenario.name = defaultScenarioName
            }
            else {defaultScenario = allScenarios[0]}
        }
        else {
            println("Coult not fetch \(error)")
        }
        return defaultScenario
    }
    
    func makeArrayOfAllInterestPayments() -> [Double]{
        var arrayOfAllPrincipalPayments = [Double]()
        var mpForAllLoans = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForAllLoans{
            let payment = payment as! MonthlyPayment
            let roundedpayment = round(payment.interest.doubleValue * 100) / 100
            arrayOfAllPrincipalPayments.append(roundedpayment)
            
        }
        return arrayOfAllPrincipalPayments
    }
    
    func makeArrayOfTotalPayments() -> [Double]{
        var arrayOfAllPrincipalPayments = [Double]()
        var mpForAllLoans = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForAllLoans{
            let payment = payment as! MonthlyPayment
            let roundedpayment = round(payment.totalPayment.doubleValue * 100) / 100
            arrayOfAllPrincipalPayments.append(roundedpayment)
        }
        return arrayOfAllPrincipalPayments
    }

//    func PAYE_WindUp(managedObjectContext:NSManagedObjectContext, AGI:Double, annualSalaryIncrease:Double, familySize:Int, PAYEReqs:Bool)
    
    
    func refinance_WindUp(managedObjectContext:NSManagedObjectContext, interest:Double, variableBool:Bool, increaseInInterest:Double, refinanceTerm:Int, oneTimePayoff : Double){
        //get all the loans as objects
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        
        var lArray = [Loan]()
        var totalPrincipalBalance : Double = 0
        
        //any loan can go into a private refinance, so we don't need to do any checking here
        for object in oSet {
            var oldLoan = object as! Loan
            totalPrincipalBalance += oldLoan.balance.doubleValue
        }
        
        //subtract any one-time payoff offered by the refinancer
        totalPrincipalBalance -= oneTimePayoff
        
        let entity = NSEntityDescription.entityForName("Loan", inManagedObjectContext: managedObjectContext)
        //set variable of what will be inserted into the entity "Loan"
        var temporaryWindUpLoan = Loan(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)

        temporaryWindUpLoan.balance = NSNumber(double: totalPrincipalBalance)
        temporaryWindUpLoan.interest = NSNumber(double: interest)
        temporaryWindUpLoan.monthsUntilRepayment = 0
        
        if variableBool == false {
            //there's no variation in interest, so we just wind up the one loan we have at the correct interest rate
            self.addPaymentsForOneLoan(managedObjectContext, loansPayments: temporaryWindUpLoan.standardFlat_WindUpLoan(refinanceTerm))
        }
        
        else {
            self.addPaymentsForOneLoan(managedObjectContext, loansPayments: temporaryWindUpLoan.refi_WindUpLoan(interest, increaseInInterest:increaseInInterest, refinanceTerm:refinanceTerm))
            //ASSUMPTION: we are going to assume that the interest rate increases one percentage point ever year.
        }
        
        managedObjectContext.deleteObject(temporaryWindUpLoan as NSManagedObject)
    }
    //var interestRateOnRefi : Double!
    //var variableInterestRate : Bool = false
    //var changeInInterestRate : Double!
    
    
    //want it to add in interestOverLife, timeToRepay, and ConcadenatedPayment
    //rename standardFlatExtraPayment_WindUp
    func standardFlatExtraPayment_WindUp (managedObjectContext:NSManagedObjectContext, extra:Double, MWEPTotal:Int, paymentTerm:Int) {
        var error: NSError?
        var description : String = ""
        //reset interestoverlife and concat payment of the scenario we are working in.
        self.interestOverLife = 0
        self.nnewScenarioMaxPayment = 0
        self.nnewTotalScenarioInterest = 0
        self.nnewTotalScenarioMonths = 0
        

        //setup default variable to count how far we are into adding the payments.
        
        var MWEPSoFar : Int = 0
        var newScenarioMonths : Int = 0
        
        let entity = NSEntityDescription.entityForName("Loan", inManagedObjectContext: managedObjectContext)
        
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            lArray.append(oldLoan)
        }
        
        lArray.sort {$0.interest.doubleValue > $1.interest.doubleValue}
        
        for loan in lArray {
            //this is standard, so each loan has 120 payments.  If it hasn't enetered repayment yet, we add the positive number of months until repayment.  if it's already in repayment, we add the negative number of months already paid.
            var loansTotalMonths = paymentTerm + loan.monthsUntilRepayment.integerValue
            
            //if we've already enough exta payments that we are past the months in the loan overall, we would never be adding extra payments to this loan, so we just add it straight away
            if MWEPSoFar >= MWEPTotal {
                //load up the loan just like normal doNothing
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(paymentTerm))
                description += "No supplemental payments were made on \(loan.name), which has an interest rate of %\(loan.interest)"
            }
                
            //else, if the the number of extra payments so far is less than the total
            else if MWEPSoFar < MWEPTotal {
                //know whether
                let endMonthForExtraPayment = minElement([MWEPTotal, loansTotalMonths])
                let enteredLoanWithExtra = loan.standardFlat_ExtraPayment_WindUpLoan(managedObjectContext, extraAmount:extra, extraStart:MWEPSoFar, extraEnd:endMonthForExtraPayment, paymentTerm: paymentTerm)
                MWEPSoFar = enteredLoanWithExtra.monthNumber
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: enteredLoanWithExtra.parray)
                description += enteredLoanWithExtra.description
            }
        }
        self.scenarioDescription = description

        //return self.interestOverLife.doubleValue
            }
    
    func makeInterestArray() -> [Double]{
        var interestArray = [Double]()
        let mpForAllLoans = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForAllLoans{
            let payment = payment as! MonthlyPayment
            let roundpayment = round(payment.interest.doubleValue * 100) / 100
            interestArray.append(roundpayment)
        }
        return interestArray
    }
    
    //toDelete
    func makeCALayerWithInterestLine(rect:CGRect, color:CGColor, maxValue:Double) -> CALayer {
        //initial variables
        let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let linePoints = self.makeArrayOfAllInterestPayments()
        println("this is scenario:")
        println(self.name)
        println("Here's the number of line points in the array")
        println(linePoints.count)
        println("and here is hte array itself")
        println(linePoints)
        let width = rect.width
        let height = rect.height
        let newCALayer = CALayer()
        newCALayer.frame = CGRectMake(0, 0, rect.width, rect.height)
        let graphPath = UIBezierPath()
        let interestLineLayer = CAShapeLayer()
        let margin:CGFloat = 20.0
        var columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((linePoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer //want to have it be default so that the x spacing is always correct
            x += margin + 2
            return x
        }
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        var columnYPoint = { (graphPoint:Double) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        //
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
            y:columnYPoint(linePoints[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<linePoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                y:columnYPoint(linePoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        interestLineLayer.path = graphPath.CGPath
        interestLineLayer.fillColor = clearColor.CGColor
        interestLineLayer.fillRule = kCAFillRuleNonZero
        interestLineLayer.strokeColor = color
        interestLineLayer.lineWidth = 3.0

        newCALayer.addSublayer(interestLineLayer)
        return newCALayer
        
    }
    
    func getScenarioMaxPayment() -> Double {
        
        return maxElement(self.makeArrayOfTotalPayments())
        
    }
    
    //toDelete
    func addLoanToDefaultScenario(loan:Loan, managedObjectContext : NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        var mpForAllLoans = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
         var mpForThisLoan = loan.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        
        while mpForAllLoans.count < self.defaultTotalScenarioMonths.integerValue {
            var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            monthlyPaymentToBeAdded.interest = 0//balance * rate
            monthlyPaymentToBeAdded.principal = 0//monthlyPayment - (balance * rate)
            monthlyPaymentToBeAdded.totalPayment = 0//monthlyPayment
            mpForAllLoans.addObject(monthlyPaymentToBeAdded)
        }
        
        var interestToBeAdded : Double = 0
        
        for index in 0...mpForThisLoan.count - 1 {
            let scenarioMP = mpForAllLoans[index] as! MonthlyPayment
            let loanMP = mpForThisLoan[index] as! MonthlyPayment
            scenarioMP.addAnotherMP(loanMP)
            interestToBeAdded = interestToBeAdded + loanMP.interest.doubleValue
        }
        
        self.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
        var error: NSError?
        self.defaultTotalScenarioInterest = self.defaultTotalScenarioInterest.doubleValue + interestToBeAdded
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }
    
    func windUpConcatenatedPaymentWithAllLoans(managedObjectContext:NSManagedObjectContext) {
        //set newInterest and newMax, but you need to already have the newTotalMonths
        
        var mpForAllLoans  = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        var allLoans = self.allLoans.mutableCopy() as! NSMutableOrderedSet
        let newTotalMonths = self.nnewTotalScenarioMonths.integerValue - 1
        //firstcreate blanks
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        
        var newInterest : Double = 0
        var newMax : Double = 0
        
        for index in 0...newTotalMonths{
            var monthlyPaymentToBeAddedToScenario = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            monthlyPaymentToBeAddedToScenario.interest = 0
            monthlyPaymentToBeAddedToScenario.principal = 0
            monthlyPaymentToBeAddedToScenario.totalPayment = 0
            
            for loan in allLoans {
                var loan = loan as! Loan
                if index < loan.mpForOneLoan.count {
                    var mpToBeAddedToMonth = loan.mpForOneLoan[index] as! MonthlyPayment
                    monthlyPaymentToBeAddedToScenario.addAnotherMP(mpToBeAddedToMonth)
                }
            }
            newInterest = newInterest + monthlyPaymentToBeAddedToScenario.interest.doubleValue
            newMax = maxElement([newMax,monthlyPaymentToBeAddedToScenario.totalPayment.doubleValue])
            mpForAllLoans.addObject(monthlyPaymentToBeAddedToScenario)
        }
        //TODO: SET THIS BACK TO NNEWTOTALSCENARIOINTEREST.  Right now you are getting around the issue of the graphedScenario sometimes being default and sometimes being the newscenario
        self.defaultTotalScenarioInterest = newInterest
        self.nnewScenarioMaxPayment = newMax
        self.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet

        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }

    func extendedFlatWindUpWithExtraPayments(managedObjectContext:NSManagedObjectContext, extraAmount:NSNumber, MWEPT:Int) -> [Double] {
        //START HERE: YOU SHOULD ADD COPY over makeNewExtraPaymentScenario for extended repayment
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        
        let maxMonthsInDefaultRepayment :Int = self.defaultTotalScenarioMonths.integerValue
        
        return [180,500] // test just so this doesn't throw and error right now
    }
    
    func scenario_DeleteAssociatedObjectsFromManagedObjectContext(managedObjectContext:NSManagedObjectContext){
        //delete the concatenatedPayment
        if self.concatenatedPayment.count > 0 {
            for MP in self.concatenatedPayment {
                managedObjectContext.deleteObject(MP as! NSManagedObject)
            }
        }
        
        //delte all loans attached to the newScenario
        if self.allLoans.count > 0 {
            for loan in self.allLoans {
                var lloan = loan as! Loan
                for payment in lloan.mpForOneLoan {
                    managedObjectContext.deleteObject(payment as! NSManagedObject)
                }
                managedObjectContext.deleteObject(loan as! NSManagedObject)
            }
        }
        //have to save, otherwise you will still have the MPs in the concatenated payment when it's passed
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }

    }
    
    func getStringOfYearAndMonthForPaymentNumber(monthNumber:Double) -> String{
        var mpNumber = monthNumber
        
        //if self.monthsUntilRepayment.doubleValue > 0 {
        //    mpNumber = monthNumber + self.monthsUntilRepayment.doubleValue
        //}
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: now)
        let nowYear = components.year
        let nowMonth = components.month
        var returnYear : Int = 0
        var returnMonth : Int = 0
        let yearsToAdd = floor(mpNumber / 12)
        let monthsToAdd = mpNumber % 12
        //println("year to add \(yearsToAdd)")
        //println("month to add \(monthsToAdd)")
        
        if nowMonth + Int(monthsToAdd) > 12 {
            returnYear = nowYear + Int(yearsToAdd) + 1
            returnMonth = nowMonth + Int(monthsToAdd) - 12
        } else{
            returnYear = nowYear + Int(yearsToAdd)
            returnMonth = nowMonth + Int(monthsToAdd)
            //println("should get in here")
            //println(returnYear)
        }
        let returnMonthString = convertMonthNumberToName(Int(returnMonth))
        
        return "\(returnMonthString) \(returnYear)"
        
    }
    
    func convertMonthNameToNumer(month:String) -> Int {
        switch month {
        case "January":
            return 1
        case "February":
            return 2
        case "March":
            return 3
        case "April":
            return 4
        case "May":
            return 5
        case "June":
            return 6
        case "July":
            return 7
        case "August":
            return 8
        case "September":
            return 9
        case "October":
            return 10
        case "November":
            return 11
        case "December":
            return 12
        default:
            println("Month didn't match")
            return 1
        }
    }
    
    func convertMonthNumberToName(month:Int) -> String {
        switch month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            println("Month didn't match")
            return "January"
        }
    }
    
    
}
