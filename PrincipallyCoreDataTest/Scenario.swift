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
    @NSManaged var scenarioDescription: String
    @NSManaged var name: String
    @NSManaged var allLoans: NSOrderedSet
    @NSManaged var concatenatedPayment: NSOrderedSet
    @NSManaged var defaultTotalScenarioInterest: NSNumber //delete
    @NSManaged var defaultTotalScenarioMonths: NSNumber //delete
    @NSManaged var nnewTotalScenarioInterest: NSNumber
    @NSManaged var nnewTotalScenarioMonths: NSNumber
    @NSManaged var nnewTotalCapitalizedInterest : NSNumber
    @NSManaged var nnewTotalPrincipal : NSNumber
    @NSManaged var forgivenBalance : NSNumber
    @NSManaged var repaymentType : String
        @NSManaged var red : NSNumber
        @NSManaged var green : NSNumber
        @NSManaged var blue : NSNumber
    @NSManaged var settings: ScenarioSettings
    
    //add an object called "scenario variables" where you store all that information.  type, true fals / numbers, etc, so that you can call it again if need be. 
    //add capitalized interest variable? 
    
    func generateRandomButConstantColor(managedObjectContext:NSManagedObjectContext){
        let RGBList : [(red:Double,green:Double,blue:Double)] = [(30,191,127),(249,154,0),(217, 56, 41),(9,64,116),(88,77,120),(211,73,49), (142,111,218),(114,194,56),(77,116,97), (214,137,160), (204,166,52),(139,91,48),(98,127,48),(100,167,189),(183,170,123),(195,76,154),(107,146,217),(203,68,103),(98,190,114),(209,82,213),(125,98,109),(111,188,166),(115,95,157),(186,167,195),(217,134,93)]
        GlobalLoanCount.sharedGlobalLoanCount.count = GlobalLoanCount.sharedGlobalLoanCount.count + 1
        //this is still not working well.  I want to use each color in the colorspace once until all 25(!) colors are used. But GlobalLoanCount seems to reset when you start the app over again -- there's not sufficient persistence.  Seems like overkill to make a Core Data entity.  For now I have a workaround with also looking to the max number of scenarios out there.  Hopefully peopl
        var count = maxElement([GlobalLoanCount.sharedGlobalLoanCount.count, CoreDataStack.getNumberofScenarios(CoreDataStack.sharedInstance)() + 1])
        let index = (25 + count) % 25
        let RGB = RGBList[index]
        self.red = RGB.red
        self.green = RGB.green
        self.blue = RGB.blue
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")}
        
    }
    
    func addTotalInterestAndPrincipalSoFarToConcatPayment(managedObjectContext:NSManagedObjectContext){
        let concatPayment = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        var totalPrincipalSoFar : Double = 0
        var totalInterestSoFar : Double = 0
        
        for month in concatPayment {
            var objectMonth = month as! MonthlyPayment
            totalPrincipalSoFar += objectMonth.principal.doubleValue
            totalInterestSoFar += objectMonth.interest.doubleValue
            objectMonth.totalPrincipalSoFar = NSNumber(double: totalPrincipalSoFar)
            objectMonth.totalInterestSoFar = NSNumber(double: totalInterestSoFar)
        }
        
        self.nnewTotalScenarioMonths = concatPayment.count
        self.nnewTotalPrincipal = totalPrincipalSoFar
        self.nnewTotalScenarioInterest = totalInterestSoFar
        
        self.concatenatedPayment = concatPayment.copy() as! NSOrderedSet
        var error: NSError?
        
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }
    
    
    func standardFlat_WindUp(managedObjectContext:NSManagedObjectContext, paymentTerm:Int) {
    
        //initialize things
        self.interestOverLife = 0
        
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
    
    func getAllEligibleLoansPayment(isIBR:Bool, isPILF:Bool) -> (monthly: Double, balance:Double) {
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var cumulativePayment : Double = 0
        var totalBalance : Double = 0
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            if oldLoan.loanType == "Direct, Subs." || oldLoan.loanType == "Direct, Unsubs."  || oldLoan.loanType == "Grad PLUS" {
                cumulativePayment += oldLoan.getStandardMonthlyPayment(120, balance: oldLoan.balance.doubleValue)
                totalBalance += oldLoan.balance.doubleValue
            }
            else if isIBR == true && isPILF == false && oldLoan.loanType == "FFEL"{
                cumulativePayment += oldLoan.getStandardMonthlyPayment(120, balance: oldLoan.balance.doubleValue)
                totalBalance += oldLoan.balance.doubleValue
            }
        }
        return (cumulativePayment, totalBalance)
        
    }
    
    func PAYE_LimitedTerm_Wrapper(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, yearsInProgram:Int){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var totalBalance : Double = 0
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            totalBalance += oldLoan.balance.doubleValue
            lArray.append(oldLoan)
        }
        var scenarioCapitalizedInterest : Double = 0
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" {
                var woundUpLoan = self.PAYE_LimitedTerm_LoanWindUp_Unsubsidized(loan, cappedPercentOfDiscretionaryIncome:10, AGI:AGI, familySize:familySize, increase:percentageincrease, numberOfYearsInProgram:yearsInProgram, isIBR:false)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else if loan.loanType == "Direct, Subs." {
                var woundUpLoan = self.PAYE_LimitedTerm_LoanWindUp_Subsidized(loan, cappedPercentOfDiscretionaryIncome:10, AGI:AGI, familySize:familySize, increase:percentageincrease, numberOfYearsInProgram:yearsInProgram, isIBR:false)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        self.nnewTotalCapitalizedInterest = scenarioCapitalizedInterest
        
        
    }
    
    func IBR_LimitedTerm_Wrapper(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, yearsInProgram:Int, newBorrower:Bool){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var totalBalance : Double = 0
        var cappedPercentage = 15
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            totalBalance += oldLoan.balance.doubleValue
            lArray.append(oldLoan)
        }
        var scenarioCapitalizedInterest : Double = 0

        if newBorrower{
            cappedPercentage = 10
        }
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "FFEL" {
                var woundUpLoan = self.PAYE_LimitedTerm_LoanWindUp_Unsubsidized(loan, cappedPercentOfDiscretionaryIncome:cappedPercentage, AGI:AGI, familySize:familySize, increase:percentageincrease, numberOfYearsInProgram:yearsInProgram, isIBR:true)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else if loan.loanType == "Direct, Subs." {
                var woundUpLoan = self.PAYE_LimitedTerm_LoanWindUp_Subsidized(loan, cappedPercentOfDiscretionaryIncome:cappedPercentage, AGI:AGI, familySize:familySize, increase:percentageincrease, numberOfYearsInProgram:yearsInProgram, isIBR:true)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        self.nnewTotalCapitalizedInterest = scenarioCapitalizedInterest
        
    }

    func IBR_Standard_Limited_LoanWindUp_Subsidized(loan:Loan, cappedPercentOfDiscretionaryIncome:Int, AGI:Double, familySize:Int, increase:Double, term:Int, isIBR:Bool) -> (pArray:[Payment_NotCoreData], capitalizedInterest:Double, forgivenBalance:Double){
        
        var balance = loan.balance.doubleValue
        var rate = ((loan.interest.doubleValue / 100) / 12)
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var excessInterest : Double = 0
        var capitalizedInterestToReturn :Double = 0
        var isPILF : Bool = false
        if term < 19 {
            isPILF = true
        }
        
        var monthlyStandardPayment = self.getAllEligibleLoansPayment(isIBR, isPILF:isPILF).monthly
        var PAYE_EligibleLoanBalance = self.getAllEligibleLoansPayment(isIBR, isPILF:isPILF).balance
        var monthsUntilRepayment = loan.monthsUntilRepayment.integerValue
        
        
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            paymentArrayToReturn.append(paymentToAdd)
            monthsUntilRepayment -= 1
        }
        
        for year in 1...term{
            var monthlyPAYEpayment = self.percentageOfDiscretionaryIncome(10, AGI:AGI, familySize:familySize, year:year, increase:increase)
            
            if monthlyStandardPayment > monthlyPAYEpayment && year <= 3 {
                var proRataPAYEPayment = monthlyPAYEpayment * (loan.balance.doubleValue / PAYE_EligibleLoanBalance)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([proRataPAYEPayment, balance * rate])
                    paymentToAdd.principal = proRataPAYEPayment - paymentToAdd.interest
                    paymentToAdd.total = proRataPAYEPayment
                    // excessInterest += maxElement([0, (balance * rate) - paymentToAdd.interest])
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                
            }
            else if monthlyStandardPayment > monthlyPAYEpayment {
                var proRataPAYEPayment = monthlyPAYEpayment * (loan.balance.doubleValue / PAYE_EligibleLoanBalance)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([proRataPAYEPayment, balance * rate])
                    paymentToAdd.principal = proRataPAYEPayment - paymentToAdd.interest
                    paymentToAdd.total = proRataPAYEPayment
                    excessInterest += maxElement([0, (balance * rate) - paymentToAdd.interest])
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                
            }
            else {
                //we're still in the program, but we no longer have financial hardship
                if isIBR{
                    capitalizedInterestToReturn += excessInterest
                    balance = balance + excessInterest
                    excessInterest = 0
                }
                    //fancy PAYE thing, where if you lose financial hardship, interest only capitalizses up to 10% of the orignal value
                else {
                    if excessInterest >= 0.1 * loan.balance.doubleValue {
                        excessInterest -= ((1.1 * loan.balance.doubleValue) - balance)
                        balance = 1.1 * loan.balance.doubleValue
                        capitalizedInterestToReturn += excessInterest
                    }
                    else {
                        capitalizedInterestToReturn += excessInterest
                        balance = balance + excessInterest
                        excessInterest = 0
                    }
                }
                var payment = loan.getStandardMonthlyPayment(120, balance: loan.balance.doubleValue)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = balance * rate
                    paymentToAdd.principal = payment - paymentToAdd.interest
                    paymentToAdd.total = payment
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                
            }
        }
        return (paymentArrayToReturn, capitalizedInterestToReturn,balance)
    }
    
    func IBR_Standard_Limited_LoanWindUp_Unsubsidized(loan:Loan, cappedPercentOfDiscretionaryIncome:Int, AGI:Double, familySize:Int, increase:Double, term:Int, isIBR:Bool) -> (pArray:[Payment_NotCoreData], capitalizedInterest:Double, forgivenBalance:Double){
        var balance = loan.balance.doubleValue
        var rate = ((loan.interest.doubleValue / 100) / 12)
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var excessInterest : Double = 0
        var capitalizedInterestToReturn :Double = 0
        var monthlyStandardPayment = self.getAllEligibleLoansPayment(isIBR, isPILF:false).monthly
        var PAYE_EligibleLoanBalance = self.getAllEligibleLoansPayment(isIBR, isPILF:false).balance
        var monthsUntilRepayment = loan.monthsUntilRepayment.integerValue
        
        
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            paymentArrayToReturn.append(paymentToAdd)
            monthsUntilRepayment -= 1
        }
        
        for year in 1...term{
            var monthlyPAYEpayment = self.percentageOfDiscretionaryIncome(Double(cappedPercentOfDiscretionaryIncome), AGI:AGI, familySize:familySize, year:year, increase:increase)
            //println("we got into IBR Loan wind up Unsubdizied and the year is \(year)")
            //println("the standard payment would be ")
            //println(monthlyStandardPayment)
            //println("the PAYE payment is")
            //println(monthlyPAYEpayment)
            
            if monthlyStandardPayment > monthlyPAYEpayment {
                var proRataPAYEPayment = monthlyPAYEpayment * (loan.balance.doubleValue / PAYE_EligibleLoanBalance)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([proRataPAYEPayment, balance * rate])
                    paymentToAdd.principal = proRataPAYEPayment - paymentToAdd.interest
                    paymentToAdd.total = proRataPAYEPayment
                    excessInterest += maxElement([0, (balance * rate) - paymentToAdd.interest])
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                
            }
            else {
                //we're still in the program, but we no longer have financial hardship
                if isIBR{
                    capitalizedInterestToReturn += excessInterest
                    balance = balance + excessInterest
                    excessInterest = 0
                }
                    //fancy PAYE thing, where if you lose financial hardship, interest only capitalizses up to 10% of the orignal value
                else {
                    if excessInterest >= 0.1 * loan.balance.doubleValue {
                        excessInterest -= ((1.1 * loan.balance.doubleValue) - balance)
                        balance = 1.1 * loan.balance.doubleValue
                        capitalizedInterestToReturn += excessInterest
                    }
                    else {
                        capitalizedInterestToReturn += excessInterest
                        balance = balance + excessInterest
                        excessInterest = 0
                    }
                }
                var payment = loan.getStandardMonthlyPayment(120, balance: loan.balance.doubleValue)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = balance * rate
                    paymentToAdd.principal = payment - paymentToAdd.interest
                    paymentToAdd.total = payment
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                
            }
        }
        return (paymentArrayToReturn, capitalizedInterestToReturn,balance)
    }
    
    func PAYE_LimitedTerm_LoanWindUp_Subsidized(loan:Loan, cappedPercentOfDiscretionaryIncome:Int, AGI:Double, familySize:Int, increase:Double, numberOfYearsInProgram:Int, isIBR:Bool) -> (pArray:[Payment_NotCoreData],capitalizedInterest:Double){
        
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var monthsUntilRepayment : Int = loan.monthsUntilRepayment.integerValue
        var balance = loan.balance.doubleValue
        var rate = (loan.interest.doubleValue / 12 ) / 100
        var excessInterest : Double = 0
        var monthlyStandardPayment = self.getAllEligibleLoansPayment(isIBR, isPILF:false).monthly //monthly payment for all PAYE_eligible laons if they were on a standard 10 year repayment plan.
        var PAYE_EligibleLoanBalance = self.getAllEligibleLoansPayment(isIBR, isPILF:false).balance
        var newBalance : Double = balance
        var capitalizedInterestToReturn : Double = 0
        
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            paymentArrayToReturn.append(paymentToAdd)
            monthsUntilRepayment -= 1
        }
        
        for year in 1...numberOfYearsInProgram{
            //wind up loan for in PAYE keeping track of capitzlized interest
            //total discretionary income available to be paid on all loans
            var monthlyPAYEpayment = self.percentageOfDiscretionaryIncome(Double(cappedPercentOfDiscretionaryIncome), AGI:AGI, familySize:familySize, year:year, increase:increase)
            
            if monthlyStandardPayment > monthlyPAYEpayment && year <= 3 {
                var proRataPAYEPayment = monthlyPAYEpayment * (loan.balance.doubleValue / PAYE_EligibleLoanBalance)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([proRataPAYEPayment, balance * rate])
                    paymentToAdd.principal = proRataPAYEPayment - paymentToAdd.interest
                    paymentToAdd.total = proRataPAYEPayment
                    // excessInterest += maxElement([0, (balance * rate) - paymentToAdd.interest])
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                
            }
            else if monthlyStandardPayment > monthlyPAYEpayment {
                var proRataPAYEPayment = monthlyPAYEpayment * (loan.balance.doubleValue / PAYE_EligibleLoanBalance)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([proRataPAYEPayment, balance * rate])
                    paymentToAdd.principal = proRataPAYEPayment - paymentToAdd.interest
                    paymentToAdd.total = proRataPAYEPayment
                    excessInterest += maxElement([0, (balance * rate) - paymentToAdd.interest])
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                
            }
            else {
                //we're still in the program, but we no longer have financial hardship
                if isIBR{
                    capitalizedInterestToReturn += excessInterest
                    balance = balance + excessInterest
                    excessInterest = 0
                }
                    //fancy PAYE thing, where if you lose financial hardship, interest only capitalizses up to 10% of the orignal value
                else {
                    if excessInterest >= 0.1 * loan.balance.doubleValue {
                        excessInterest -= ((1.1 * loan.balance.doubleValue) - balance)
                        balance = 1.1 * loan.balance.doubleValue
                        capitalizedInterestToReturn += excessInterest
                    }
                    else {
                        capitalizedInterestToReturn += excessInterest
                        balance = balance + excessInterest
                        excessInterest = 0
                    }
                }
                var payment = loan.getStandardMonthlyPayment(120, balance: loan.balance.doubleValue)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = balance * rate
                    paymentToAdd.principal = payment - paymentToAdd.interest
                    paymentToAdd.total = payment
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                
            }
        }
        
        
        balance += excessInterest
        capitalizedInterestToReturn += excessInterest
        let remainingYears = 10 - numberOfYearsInProgram
        var r = rate
        var PV = balance
        var n:Double = -1 * Double(remainingYears) * 12
        var paymentToBeDoneIn10Years = (r * PV) / (1 - pow((1+r),n))
        
        while balance > paymentToBeDoneIn10Years{
            var paymentToAdd = Payment_NotCoreData()
            paymentToAdd.interest = balance * rate
            paymentToAdd.principal = paymentToBeDoneIn10Years - paymentToAdd.interest
            paymentToAdd.total = paymentToBeDoneIn10Years
            paymentArrayToReturn.append(paymentToAdd)
            balance -= paymentToAdd.principal
        }
        //lastPayment
        var lastpayment = Payment_NotCoreData()
        lastpayment.principal = balance
        lastpayment.interest = balance * rate
        lastpayment.total = balance + (balance * rate)
        paymentArrayToReturn.append(lastpayment)
        //return
        return (paymentArrayToReturn,capitalizedInterestToReturn)
        
    }
    
    func PAYE_LimitedTerm_LoanWindUp_Unsubsidized(loan:Loan, cappedPercentOfDiscretionaryIncome:Int, AGI:Double, familySize:Int, increase:Double, numberOfYearsInProgram:Int, isIBR:Bool) -> (pArray:[Payment_NotCoreData],capitalizedInterest:Double){
        
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var monthsUntilRepayment : Int = loan.monthsUntilRepayment.integerValue
        var balance = loan.balance.doubleValue
        var rate = (loan.interest.doubleValue / 12 ) / 100
        var excessInterest : Double = 0
        var monthlyStandardPayment = self.getAllEligibleLoansPayment(isIBR, isPILF:false).monthly //monthly payment for all PAYE_eligible laons if they were on a standard 10 year repayment plan.
        var PAYE_EligibleLoanBalance = self.getAllEligibleLoansPayment(isIBR, isPILF:false).balance
        var newBalance : Double = balance
        var capitalizedInterestToReturn : Double = 0
        
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            paymentArrayToReturn.append(paymentToAdd)
            monthsUntilRepayment -= 1
        }
        
        for year in 1...numberOfYearsInProgram{
            //wind up loan for in PAYE keeping track of capitzlized interest
            //total discretionary income available to be paid on all loans 
            var monthlyPAYEpayment = self.percentageOfDiscretionaryIncome(Double(cappedPercentOfDiscretionaryIncome), AGI:AGI, familySize:familySize, year:year, increase:increase)
            
            if monthlyStandardPayment > monthlyPAYEpayment {
                var proRataPAYEPayment = monthlyPAYEpayment * (loan.balance.doubleValue / PAYE_EligibleLoanBalance)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([proRataPAYEPayment, balance * rate])
                    paymentToAdd.principal = proRataPAYEPayment - paymentToAdd.interest
                    paymentToAdd.total = proRataPAYEPayment
                    excessInterest += maxElement([0, (balance * rate) - paymentToAdd.interest])
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }

            }
            else {
                //we've exited the program, and now we do the 10 year loan amount.  First we capitalized interest.
                capitalizedInterestToReturn += excessInterest
                balance = balance + excessInterest
                excessInterest = 0
                var payment = loan.getStandardMonthlyPayment(120, balance: loan.balance.doubleValue)
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = balance * rate
                    paymentToAdd.principal = payment - paymentToAdd.interest
                    paymentToAdd.total = payment
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
            }
            
        }
        }
        
        
        balance += excessInterest
        capitalizedInterestToReturn += excessInterest
        let remainingYears = 10 - numberOfYearsInProgram
        var r = rate
        var PV = balance
        var n:Double = -1 * Double(remainingYears) * 12
        var paymentToBeDoneIn10Years = (r * PV) / (1 - pow((1+r),n))
        
        while balance > paymentToBeDoneIn10Years{
            var paymentToAdd = Payment_NotCoreData()
            paymentToAdd.interest = balance * rate
            paymentToAdd.principal = paymentToBeDoneIn10Years - paymentToAdd.interest
            paymentToAdd.total = paymentToBeDoneIn10Years
            paymentArrayToReturn.append(paymentToAdd)
            balance -= paymentToAdd.principal
        }
        //lastPayment
        var lastpayment = Payment_NotCoreData()
        lastpayment.principal = balance
        lastpayment.interest = balance * rate
        lastpayment.total = balance + (balance * rate)
        paymentArrayToReturn.append(lastpayment)
        //return
        return (paymentArrayToReturn,capitalizedInterestToReturn)
        
    }
    
    func ICR_LimitedTerm_Wrapper(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, headOfHousehold:Bool, term:Int){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var totalBalance : Double = 0
        var monthsUntilRepayment = 0
        
        
        var ICR_Eligible_Balance : Double = 0
        var ICR_Eligible_Interest : Double = 0
        
        var eligible_lArray = [Loan]()
        var ineligible_lArray = [Loan]()
        
        for object in oSet {
            var oldLoan = object as! Loan
            if oldLoan.loanType == "Direct, Unsubs."  || oldLoan.loanType == "Grad PLUS" || oldLoan.loanType == "Direct, Subs."{
                ICR_Eligible_Balance += oldLoan.balance.doubleValue
                eligible_lArray.append(oldLoan)
                monthsUntilRepayment  = oldLoan.monthsInRepaymentTerm.integerValue
            }
            else {
                ineligible_lArray.append(oldLoan)
            }
        }
        
        //get balance and weighted interest for all ICR eligible loans
        for loan in eligible_lArray{
            ICR_Eligible_Interest += loan.interest.doubleValue * (loan.balance.doubleValue / ICR_Eligible_Balance)
        }
        //println("we are in ICR limited term and the interest/balance is")
        //println(ICR_Eligible_Balance)
        //println(ICR_Eligible_Interest)
        //println("ICR will fun for \(term) number of years")
        var woundUpLoan = self.ICR_LimitedTerm_LoanWindUp(ICR_Eligible_Balance, interest: ICR_Eligible_Interest, AGI:AGI, familySize:familySize, percentageincrease:percentageincrease, term:term, headOfHousehold:headOfHousehold)
        
        //take into account if you aren't going into repyament just yet
        //assumption: All ICR-eligible loans will enter repayment at the same time
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            woundUpLoan.pArray.insert(paymentToAdd, atIndex: 0)
            monthsUntilRepayment -= 1
        }
        
        
        self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
        self.nnewTotalCapitalizedInterest = NSNumber(double: woundUpLoan.capitalizedInterest)
        self.forgivenBalance = 0 //because we'll finish in 10 years no matter what, there shouldn't be any forgiven balance.
        
        for loan in ineligible_lArray{
            self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
        }
        

    }
    
    func ICR_PILF_or_Standard_Wrapper(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, headOfHousehold:Bool, term:Int){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var totalBalance : Double = 0
        var monthsUntilRepayment = 0
        
        var ICR_Eligible_Balance : Double = 0
        var ICR_Eligible_Interest : Double = 0
        
        var eligible_lArray = [Loan]()
        var ineligible_lArray = [Loan]()
        
        for object in oSet {
            var oldLoan = object as! Loan
            if oldLoan.loanType == "Direct, Unsubs."  || oldLoan.loanType == "Grad PLUS" || oldLoan.loanType == "Direct, Subs."{
                ICR_Eligible_Balance += oldLoan.balance.doubleValue
                eligible_lArray.append(oldLoan)
                monthsUntilRepayment = oldLoan.monthsUntilRepayment.integerValue
            }
            else {
                ineligible_lArray.append(oldLoan)
            }
        }
        
        //get balance and weighted interest for all ICR eligible loans
        for loan in eligible_lArray{
            ICR_Eligible_Interest += loan.interest.doubleValue * (loan.balance.doubleValue / ICR_Eligible_Balance)
        }
        //println("we are in ICR with PILF and the interest/balance is")
        //println(ICR_Eligible_Balance)
        //println(ICR_Eligible_Interest)
        var woundUpLoan = self.ICR_Standard_Or_PILF_OneLoan_WindUp(ICR_Eligible_Balance, interest: ICR_Eligible_Interest, AGI:AGI, familySize:familySize, percentageincrease:percentageincrease, term:term, headOfHousehold:headOfHousehold)
        
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            woundUpLoan.pArray.insert(paymentToAdd, atIndex: 0)
            monthsUntilRepayment -= 1
        }
        
        self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
        self.nnewTotalCapitalizedInterest = NSNumber(double: woundUpLoan.capitalizedInterest)
        self.forgivenBalance = NSNumber(double: woundUpLoan.forgivenBalance)
        
        for loan in ineligible_lArray{
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
        }

    }
    
    func ICR_LimitedTerm_LoanWindUp(balance:Double, interest: Double, AGI:Double, familySize:Int, percentageincrease:Double, term:Int, headOfHousehold:Bool) -> (pArray:[Payment_NotCoreData], capitalizedInterest:Double){
        
        var bbalance = balance
        var rate = ((interest / 100) / 12)
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var excessInterest : Double = 0
        var capitalizedInterestToReturn :Double = 0
        
        for year in 1...term{
            let payment = self.ICR_Payment(balance, interest: interest, AGI: AGI, familySize: familySize, percentageIncrease: percentageincrease, year: year, headOfHousehold: headOfHousehold)
            
            for month in 1...12{
                if bbalance > payment {
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([payment, bbalance * rate])
                    paymentToAdd.principal = payment - paymentToAdd.interest
                    paymentToAdd.total = payment
                    excessInterest += maxElement([0, (bbalance * rate) - paymentToAdd.interest])
                    bbalance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                else if bbalance == 0 {
                    break
                }
                else {
                    var lastPaymentToAdd = Payment_NotCoreData()
                    lastPaymentToAdd.interest = bbalance * rate
                    lastPaymentToAdd.principal = bbalance
                    lastPaymentToAdd.total = bbalance + lastPaymentToAdd.interest
                    bbalance = 0
                    paymentArrayToReturn.append(lastPaymentToAdd)
                    break
                }
            }
            if bbalance + excessInterest < balance * 1.1 {
                bbalance = bbalance + excessInterest
                capitalizedInterestToReturn += excessInterest
                excessInterest = 0
            }
            else {
                //we are at the 10% cap
                let cap = balance * 1.1
                excessInterest = excessInterest - (cap - bbalance)
                capitalizedInterestToReturn += (cap - bbalance)
                bbalance = cap
            }
        }
        //now we exit IBR, so in the remaining interest compounds
        bbalance += excessInterest
        capitalizedInterestToReturn += excessInterest
        let remainingYears = 10 - term
        var r = (interest / 100) / 12
        var PV = bbalance
        var n:Double = -1 * Double(remainingYears) * 12
        var paymentToBeDoneIn10Years = (r * PV) / (1 - pow((1+r),n))
        
        while bbalance > paymentToBeDoneIn10Years{
            var paymentToAdd = Payment_NotCoreData()
            paymentToAdd.interest = bbalance * rate
            paymentToAdd.principal = paymentToBeDoneIn10Years - paymentToAdd.interest
            paymentToAdd.total = paymentToBeDoneIn10Years
            paymentArrayToReturn.append(paymentToAdd)
            bbalance -= paymentToAdd.principal
        }
        //lastPayment
        var lastpayment = Payment_NotCoreData()
        lastpayment.principal = bbalance
        lastpayment.interest = bbalance * rate
        lastpayment.total = bbalance + (bbalance * rate)
        paymentArrayToReturn.append(lastpayment)
        //return
        return (paymentArrayToReturn,capitalizedInterestToReturn)
    }

    func ICR_Standard_Or_PILF_OneLoan_WindUp(balance:Double, interest: Double, AGI:Double, familySize:Int, percentageincrease:Double, term:Int, headOfHousehold:Bool) -> (pArray:[Payment_NotCoreData], capitalizedInterest:Double, forgivenBalance:Double){
        
        var bbalance = balance
        var rate = ((interest / 100) / 12)
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var excessInterest : Double = 0
        var capitalizedInterestToReturn :Double = 0
        
        for year in 1...term{
            let payment = self.ICR_Payment(balance, interest: interest, AGI: AGI, familySize: familySize, percentageIncrease: percentageincrease, year: year, headOfHousehold: headOfHousehold)
            
            for month in 1...12{
                if bbalance > payment {
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([payment, bbalance * rate])
                    paymentToAdd.principal = payment - paymentToAdd.interest
                    paymentToAdd.total = payment
                    excessInterest += maxElement([0, (bbalance * rate) - paymentToAdd.interest])
                    bbalance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                else if bbalance == 0 {
                    break
                }
                else {
                    var lastPaymentToAdd = Payment_NotCoreData()
                    lastPaymentToAdd.interest = bbalance * rate
                    lastPaymentToAdd.principal = bbalance
                    lastPaymentToAdd.total = bbalance + lastPaymentToAdd.interest
                    bbalance = 0
                    paymentArrayToReturn.append(lastPaymentToAdd)
                    break
                }
            }
            if bbalance + excessInterest < balance * 1.1 {
                bbalance = bbalance + excessInterest
                capitalizedInterestToReturn += excessInterest
                excessInterest = 0
            }
            else {
                //we are at the 10% cap
                let cap = balance * 1.1
                excessInterest = excessInterest - (cap - bbalance)
                capitalizedInterestToReturn += (cap - bbalance)
                bbalance = cap
            }
        }
        //println("here is the capitalized interest")
        //println(capitalizedInterestToReturn)
        //println("here is the cancelled balance")
        //println(bbalance)
        return (paymentArrayToReturn, capitalizedInterestToReturn, bbalance)
    }
    
    func ICR_Payment(balance:Double, interest:Double, AGI:Double, familySize:Int, percentageIncrease:Double, year:Int, headOfHousehold:Bool) -> Double {
        
        //first, calculate 12 year amortization * percentage of discretionary income
        var r = (interest / 100) / 12
        var PV = balance
        var n :Double = -144
        
        var twelveYearMonthlyPayment = (r * PV) / (1 - pow((1+r),n))
        
        var currentIncome = AGI * pow(1 + (percentageIncrease / 100),Double(year-1))
        var percentmultiplier = self.ICR_getIncomePercentage(currentIncome, headOfHousehold:headOfHousehold)
        var twelveYearTimesIncomePercentage = twelveYearMonthlyPayment * percentmultiplier
        
        //second, calculate 20% of discretionary income 
        let twentyPercentOfDiscretionaryIncomeMonthly = self.ICR_percentageOfDiscretionaryIncome(20, AGI:AGI, familySize:familySize, year:year, increase:percentageIncrease)
        //println("here's the twelve year amortaized monthly")
          //  println(twelveYearMonthlyPayment)
           // println("here's the percent")
           // println(percentmultiplier)
           // println("here's the 12year times percent")
           // println(twelveYearTimesIncomePercentage)
           // println("here's the 20% of the discretionary income")
           // println(twentyPercentOfDiscretionaryIncomeMonthly)
        //return the lesser of the two
        return minElement([twelveYearTimesIncomePercentage,twentyPercentOfDiscretionaryIncomeMonthly])
    }
    
    func ICR_getIncomePercentage(income:Double, headOfHousehold:Bool) -> Double {
        //println("got into getIncomePercentage")
        
        let singleArray : [(income:Double, percent:Double)] = [(income:11150, percent:0.5500),
        (income:15342, percent:0.5779),
        (income:19741, percent:0.6057),
        (income:24240, percent:0.6623),
        (income:28537, percent:0.7189),
        (income:33954, percent:0.8033),
        (income:42648, percent:0.8877),
        (income:53488, percent:1.0),
            (income:64331, percent:1.0),
            (income:77318, percent:1.1180),
            (income:99003, percent:1.2350),
            (income:140221, percent:1.4120),
            (income:160776, percent:1.5000),
            (income:286370, percent:2.0)]
        
        let hoHArray : [(income:Double, percent:Double)] = [(income:11150, percent:0.5052),
            (income:17593, percent:0.5668),
            (income:20965, percent:0.5956),
            (income:27408, percent:0.6779),
            (income:33954, percent:0.7522),
            (income:42648, percent:0.8761),
            (income:53487, percent:1.0),
            (income:64331, percent:1.0),
            (income:80596, percent:1.0940),
            (income:107695, percent:1.25),
            (income:145638, percent:1.4060),
            (income:203682, percent:1.50),
            (income:332833, percent:2.0)]
        
        if headOfHousehold {
            for index in 1...hoHArray.count-1 {
                //println("got into the for loop in getIncomePercentage")
                //println(income)
                //println( hoHArray[index].income)
                if income <= hoHArray[index].income {
                    let i2 = hoHArray[index].income
                    let i1 = hoHArray[index-1].income
                    let p2 = hoHArray[index].percent
                    let p1 = hoHArray[index-1].percent
                    let pdiff = p2 - p1
                    let idiff = i2 - i1
                    return p1 + (((income - i1) / idiff) * pdiff)
                }
            }
            return 2
        }
        else {
            
            for index in 1...singleArray.count-1 {
                if income <= singleArray[index].income {
                    let i2 = singleArray[index].income
                    let i1 = singleArray[index-1].income
                    let p2 = singleArray[index].percent
                    let p1 = singleArray[index-1].percent
                    let pdiff = p2 - p1
                    let idiff = i2 - i1
                    return p1 + (((income - i1) / idiff) * pdiff)

                }
            }
            return 2
        }
    }
    
    func ICR_percentageOfDiscretionaryIncome(percentOfDI: Double, AGI:Double, familySize:Int, year:Int, increase:Double) -> Double {
        //println([percentOfDI, AGI, familySize, year, increase])
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
        
        //let OneHundredFiftyPercentOfFPG = FPG * 1.5
        adjustedGrossIncome = adjustedGrossIncome * pow(1 + (increase/100),Double(year-1))
        
        let discretionaryIncome = maxElement([(adjustedGrossIncome - FPG), 0])
        let percentOfDiscretionaryIncome = (percentOfDI/100) * discretionaryIncome
        let percentOfDiscretionaryIncomeForEachMonth = percentOfDiscretionaryIncome / 12
        return percentOfDiscretionaryIncomeForEachMonth
        
    }
    
    /*
    func IBR_WindUp(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, term:Int, percent:Double, hasPILF:Bool, hasLimitedTimeInProgram:Bool, yearsInProgram:Int){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var totalBalance : Double = 0
        var directLoanTerm = term
        
        if hasPILF{
            directLoanTerm = 10
        }
        
        var yearsInTheProgram = 25
        
        if hasLimitedTimeInProgram{
            yearsInTheProgram = yearsInProgram
        }
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            totalBalance += oldLoan.balance.doubleValue
            lArray.append(oldLoan)
        }
        
        var scenarioCapitalizedInterest : Double = 0
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" {
                var woundUpLoan = self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:percent, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:false, isIBR:true, term:directLoanTerm, numberOfYearsInProgram:yearsInTheProgram)
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.parray)
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else if loan.loanType == "FFEL"{
                var woundUpLoan = self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:percent, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:false, isIBR:true, term:term, numberOfYearsInProgram:yearsInTheProgram)
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.parray)
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else if loan.loanType == "Direct, Subs." {
                var woundUpLoan = self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:percent, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:true, isIBR:true, term:directLoanTerm, numberOfYearsInProgram:yearsInTheProgram)
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.parray)
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        
        self.nnewTotalCapitalizedInterest = scenarioCapitalizedInterest
        
    }
    */
    /*func PAYE_WindUp(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, hasPILF:Bool, hasLimitedTimeInProgram:Bool, yearsInProgram:Int){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var totalBalance : Double = 0
        var PAYETerm = 20
        if hasPILF{
            PAYETerm = 10
        }
        
        var yearsInTheProgram = 20
        
        if hasLimitedTimeInProgram{
            yearsInTheProgram = yearsInProgram
        }
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            totalBalance += oldLoan.balance.doubleValue
            lArray.append(oldLoan)
        }
        
        var scenarioCapitalizedInterest : Double = 0
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" {
                var woundUpLoan = self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:10, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:false, isIBR:false, term:PAYETerm, numberOfYearsInProgram:yearsInTheProgram)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.parray)
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else if loan.loanType == "Direct, Subs." {
                var woundUpLoan = self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:10, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:true, isIBR:false, term:PAYETerm, numberOfYearsInProgram:yearsInTheProgram)
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.parray)
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        
        self.nnewTotalCapitalizedInterest = scenarioCapitalizedInterest 

    }
  */
    
    /*
    func incomeDriven_OneLoan_Wind_Up(totalBalance:Double, loan:Loan, percent:Double, AGI:Double, familySize:Int, increase:Double, subsidized:Bool, isIBR:Bool, term:Int, numberOfYearsInProgram:Int) -> (parray: [Payment_NotCoreData], capitalizedInterest:Double, forgivenBalance:Double){
        
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var monthsUntilRepayment : Int = loan.monthsUntilRepayment.integerValue
        var balance = loan.balance.doubleValue
        var rate = (loan.interest.doubleValue / 12 ) / 100
        var excessInterest : Double = 0
        var monthlyStandardPayment = self.getAllEligibleLoansPayment(isIBR).monthly //monthly
        var newBalance : Double = balance
        var capitalizedInterestToReturn : Double = 0
        
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            paymentArrayToReturn.append(paymentToAdd)
            monthsUntilRepayment -= 1
        }
        
        for year in 1...term{
            let monthlyPAYEpayment = self.percentageOfDiscretionaryIncome(percent, AGI:AGI, familySize:familySize, year:year, increase:increase)
            
            if monthlyStandardPayment > monthlyPAYEpayment && subsidized == true && year <= 3 && year <= numberOfYearsInProgram {
                var proRataPAYEPayment = monthlyPAYEpayment * (loan.balance.doubleValue / totalBalance)
                
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([proRataPAYEPayment, balance * rate])
                    paymentToAdd.principal = proRataPAYEPayment - paymentToAdd.interest
                    paymentToAdd.total = proRataPAYEPayment
                    //excessInterest += maxElement([0, (balance * rate) - paymentToAdd.interest])
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                newBalance = balance + excessInterest //if interest capitalized
                
            }
                
            else if monthlyStandardPayment > monthlyPAYEpayment && year <= numberOfYearsInProgram {
                
                var proRataPAYEPayment = monthlyPAYEpayment * (loan.balance.doubleValue / totalBalance)
                
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = minElement([proRataPAYEPayment, balance * rate])
                    paymentToAdd.principal = proRataPAYEPayment - paymentToAdd.interest
                    paymentToAdd.total = proRataPAYEPayment
                    excessInterest += maxElement([0, (balance * rate) - paymentToAdd.interest])
                    balance -= paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                }
                newBalance = balance + excessInterest //if interest capitalized
            }
            else if year > numberOfYearsInProgram {
                //here is what happens if you leave IBR after being partially finished.  Now your loan payment is based on the number of years remaining in the 10 year term. 
                capitalizedInterestToReturn = excessInterest
                var proRataStandardPayment = loan.getStandardMonthlyPayment(120-numberOfYearsInProgram*12, balance: newBalance)
                for month in 1...12{
                    if newBalance > proRataStandardPayment {
                        var paymentToAdd = Payment_NotCoreData()
                        paymentToAdd.interest = rate * newBalance
                        paymentToAdd.principal = proRataStandardPayment - paymentToAdd.interest
                        paymentToAdd.total = proRataStandardPayment
                        newBalance -= paymentToAdd.principal
                        paymentArrayToReturn.append(paymentToAdd)
                    }
                    else if newBalance == 0 {
                        //do nothing, don't add any payment
                        break
                    }
                    else {
                        var lastPaymentToAdd = Payment_NotCoreData()
                        lastPaymentToAdd.interest = newBalance * rate
                        lastPaymentToAdd.principal = newBalance
                        lastPaymentToAdd.total = newBalance + lastPaymentToAdd.interest
                        newBalance = 0
                        paymentArrayToReturn.append(lastPaymentToAdd)
                        break
                    }
                    
                    
                }

                
            }
            else {
                capitalizedInterestToReturn = excessInterest
                var proRataStandardPayment = loan.getStandardMonthlyPayment(120, balance: loan.balance.doubleValue)
                
                for month in 1...12{
                    if newBalance > proRataStandardPayment {
                        var paymentToAdd = Payment_NotCoreData()
                        paymentToAdd.interest = rate * newBalance
                        paymentToAdd.principal = proRataStandardPayment - paymentToAdd.interest
                        paymentToAdd.total = proRataStandardPayment
                        newBalance -= paymentToAdd.principal
                        paymentArrayToReturn.append(paymentToAdd)
                    }
                    else if newBalance == 0 {
                        //do nothing, don't add any payment 
                        break
                    }
                    else {
                        var lastPaymentToAdd = Payment_NotCoreData()
                        lastPaymentToAdd.interest = newBalance * rate
                        lastPaymentToAdd.principal = newBalance
                        lastPaymentToAdd.total = newBalance + lastPaymentToAdd.interest
                        newBalance = 0
                        paymentArrayToReturn.append(lastPaymentToAdd)
                        break
                    }
                    
                    
                }
            }
        }
        return (paymentArrayToReturn, capitalizedInterestToReturn, newBalance)
        
    }
*/
    func PAYE_Standard_Or_PILF_Wrapper(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, term:Int){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        
        //println("we are in PAYE standard")
        
        let oSet = defaultScenario.allLoans
        var cappedPercentage = 10
        
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            lArray.append(oldLoan)
        }
        var scenarioCapitalizedInterest : Double = 0
        var forgivenBalance: Double = 0
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" {
                //println("It properly realized that the loan is unsubsidized")
                var woundUpLoan = self.IBR_Standard_Limited_LoanWindUp_Unsubsidized(loan, cappedPercentOfDiscretionaryIncome:cappedPercentage, AGI:AGI, familySize:familySize, increase:percentageincrease, term:term, isIBR:false)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                forgivenBalance += woundUpLoan.forgivenBalance
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            
            else if loan.loanType == "Direct, Subs." {
                var woundUpLoan = self.IBR_Standard_Limited_LoanWindUp_Subsidized(loan, cappedPercentOfDiscretionaryIncome:cappedPercentage, AGI:AGI, familySize:familySize, increase:percentageincrease, term:term, isIBR:false)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                forgivenBalance += woundUpLoan.forgivenBalance
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        self.nnewTotalCapitalizedInterest = scenarioCapitalizedInterest
        self.forgivenBalance = forgivenBalance
        
    }
    
    func IBR_Standard_Or_PILF_Wrapper(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, term:Int, newBorrower:Bool){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var cappedPercentage = 15

        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            lArray.append(oldLoan)
        }
        var scenarioCapitalizedInterest : Double = 0
        var forgivenBalance: Double = 0
        
        if newBorrower == true {
            cappedPercentage = 10
        }
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" {
                var woundUpLoan = self.IBR_Standard_Limited_LoanWindUp_Unsubsidized(loan, cappedPercentOfDiscretionaryIncome:cappedPercentage, AGI:AGI, familySize:familySize, increase:percentageincrease, term:term, isIBR:true)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                forgivenBalance += woundUpLoan.forgivenBalance
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else if loan.loanType == "FFEL"{
                if term < 19 {
                    //if we are in PILF, we will pay off FFEL with the rest of the non-eligible things, since FFEL isn't eliegible for cancellation with PILF.  if we are in extended repayment 20 or 25 years then we'll do it
                    self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
                }
                else {
                    var woundUpLoan = self.IBR_Standard_Limited_LoanWindUp_Unsubsidized(loan, cappedPercentOfDiscretionaryIncome:cappedPercentage, AGI:AGI, familySize:familySize, increase:percentageincrease, term:term, isIBR:true)
                
                    self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                    forgivenBalance += woundUpLoan.forgivenBalance
                    scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
                }
            }
            else if loan.loanType == "Direct, Subs." {
                var woundUpLoan = self.IBR_Standard_Limited_LoanWindUp_Subsidized(loan, cappedPercentOfDiscretionaryIncome:cappedPercentage, AGI:AGI, familySize:familySize, increase:percentageincrease, term:term, isIBR:true)
                
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: woundUpLoan.pArray)
                forgivenBalance += woundUpLoan.forgivenBalance
                scenarioCapitalizedInterest += woundUpLoan.capitalizedInterest
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        self.nnewTotalCapitalizedInterest = scenarioCapitalizedInterest
        self.forgivenBalance = forgivenBalance

    }
    
    
    func percentageOfDiscretionaryIncome(percentOfDI: Double, AGI:Double, familySize:Int, year:Int, increase:Double) -> Double {
        //println([percentOfDI, AGI, familySize, year, increase])
        //if all eligible laons were on a standard 10-year repayment plan, it would exceed 15 percent of their discretionary income
        //this will return
        //ASSUMPTION: Federal poverty guidelines for 48 continguous states
        let FPG : Double!
        var adjustedGrossIncome : Double = AGI
        println("the AGI is \(AGI)")
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
        /*
        //old federal poverty guidelines for testing
        case 1:
            FPG = 11670
        case 2:
            FPG = 15730
        case 3:
            FPG = 19790
        case 4:
            FPG = 23850
        case 5:
            FPG = 27910
        case 6:
            FPG = 31970
        case 7:
            FPG = 36030
        case 8:
            FPG = 40090
        default:
            FPG = 11670
}
        //println("after the switch, the correct federal poverty guideline is \(FPG)")

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
*/
        
        let OneHundredFiftyPercentOfFPG = FPG * 1.5
        
        adjustedGrossIncome = adjustedGrossIncome * pow(1 + (increase/100),Double(year - 1))
        //println("the AGI adjusted for the yearly increase is \(adjustedGrossIncome)")
        let discretionaryIncome = maxElement([(adjustedGrossIncome - OneHundredFiftyPercentOfFPG), 0])
        
        //println("your discretionary income is \(discretionaryIncome)")

        let percentOfDiscretionaryIncome = (percentOfDI/100) * discretionaryIncome
        let percentOfDiscretionaryIncomeForEachMonth = percentOfDiscretionaryIncome / 12
        
        //println(percentOfDiscretionaryIncome)
          //      println(percentOfDiscretionaryIncomeForEachMonth)
        return percentOfDiscretionaryIncomeForEachMonth
        
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
        //println("this is scenario:")
        //println(self.name)
        //println("Here's the number of line points in the array")
        //println(linePoints.count)
        //println("and here is hte array itself")
        //println(linePoints)
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
            //println("Month didn't match")
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
            //println("Month didn't match")
            return "January"
        }
    }
    
    
}
