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
        self.concatenatedPayment = concatPayment.copy() as! NSOrderedSet
        var error: NSError?
        
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }
    
    
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
    
    func getAllEligibleLoansPayment(isIBR:Bool) -> Double {
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var cumulativePayment : Double = 0
        
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            if oldLoan.loanType == "Direct, Subs." || oldLoan.loanType == "Direct, Unsubs."  || oldLoan.loanType == "Grad PLUS" {
                cumulativePayment += oldLoan.getStandardMonthlyPayment(120, balance: oldLoan.balance.doubleValue)
            }
            else if isIBR == true && oldLoan.loanType == "FFEL"{
                cumulativePayment += oldLoan.getStandardMonthlyPayment(120, balance: oldLoan.balance.doubleValue)
            }
        }
        return cumulativePayment
        
    }
    
    func PAYE_WindUp(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, hasPILF:Bool, hasLimitedTimeInProgram:Bool, yearsInProgram:Int){
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
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" {
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:10, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:false, isIBR:false, term:PAYETerm, numberOfYearsInProgram:yearsInTheProgram))
            }
            else if loan.loanType == "Direct, Subs." {
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:10, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:true, isIBR:false, term:PAYETerm, numberOfYearsInProgram:yearsInTheProgram))
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }

    }
    
    func ICR_WindUp(managedObjectContext: NSManagedObjectContext, AGI:Double, familySize:Int, percentageincrease:Double, hasPILF:Bool, hasLimitedTimeInProgram:Bool, yearsInProgram:Int){
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var totalBalance : Double = 0
        var termOfICR = 25
        
        if hasPILF{
           termOfICR = 10
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
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "Direct, Subs."{
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:20, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:false, isIBR:false, term:termOfICR, numberOfYearsInProgram:yearsInTheProgram))
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        
    }
    
    
    
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
        
        for loan in lArray{
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" {
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:percent, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:false, isIBR:true, term:directLoanTerm, numberOfYearsInProgram:yearsInTheProgram ))
            }
            else if loan.loanType == "FFEL"{
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:percent, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:false, isIBR:true, term:term, numberOfYearsInProgram:yearsInTheProgram))
            }
            else if loan.loanType == "Direct, Subs." {
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: self.incomeDriven_OneLoan_Wind_Up(totalBalance, loan:loan, percent:percent, AGI:AGI, familySize:familySize, increase:percentageincrease, subsidized:true, isIBR:true, term:directLoanTerm, numberOfYearsInProgram:yearsInTheProgram ))
            }
            else{
                
                //if it's not eligible, just add up the standard 10 year plan
                //ASSUMPTION: IF the loan's not eligible, you put it on the 10 year plan
                self.addPaymentsForOneLoan(managedObjectContext, loansPayments: loan.standardFlat_WindUpLoan(120))
            }
        }
        
    }
    
    //START HERE: Work in IBR Plan? 
    
    func ICR_OneLoan_Wind_Up(totalBalance:Double, loan:Loan, percent:Double, AGI:Double, familySize:Int, increase:Double, subsidized:Bool, isIBR:Bool, term:Int, numberOfYearsInProgram:Int)-> [Payment_NotCoreData]{
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var monthsUntilRepayment : Int = loan.monthsUntilRepayment.integerValue
        var balance = loan.balance.doubleValue
        var rate = (loan.interest.doubleValue / 12 ) / 100
        var excessInterest : Double = 0
        var monthlyStandardPayment = self.getAllEligibleLoansPayment(isIBR) //monthly
        var newBalance : Double = balance

        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            paymentArrayToReturn.append(paymentToAdd)
            monthsUntilRepayment -= 1
        }
        /*
        If your payments are not large enough to cover the interest that has accumulated on your loans, the unpaid amount will be capitalized (added to the loan principal) once each year. However, the amount of this capitalization is limited. If your principal becomes 10 percent greater than the amount you originally owed when you entered repayment, interest will continue to accrue but will not capitalize.
        */
        for year in 1...term{
            let monthlyPAYEpayment = self.percentageOfDiscretionaryIncome(percent, AGI:AGI, familySize:familySize, year:year, increase:increase)
            
            if monthlyStandardPayment > monthlyPAYEpayment && year <= numberOfYearsInProgram {
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
                if balance + excessInterest < loan.balance.doubleValue * 1.1 {
                    balance = balance + excessInterest
                    excessInterest = 0
                }
                else {
                    //we are at the 10% cap
                    let cap = loan.balance.doubleValue * 1.1
                    excessInterest = excessInterest - (cap - balance)
                    balance = cap
                }
                
                newBalance = balance + excessInterest
            }
            else {
                var proRataStandardPayment = loan.getStandardMonthlyPayment(120-year*12, balance: newBalance)
                
                for month in 1...12{
                    if newBalance > proRataStandardPayment {
                        var paymentToAdd = Payment_NotCoreData()
                        paymentToAdd.interest = rate * newBalance
                        paymentToAdd.principal = proRataStandardPayment - paymentToAdd.interest
                        paymentToAdd.total = proRataStandardPayment
                        newBalance -= paymentToAdd.principal
                        paymentArrayToReturn.append(paymentToAdd)
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
         return paymentArrayToReturn
    }
    
    
    func incomeDriven_OneLoan_Wind_Up(totalBalance:Double, loan:Loan, percent:Double, AGI:Double, familySize:Int, increase:Double, subsidized:Bool, isIBR:Bool, term:Int, numberOfYearsInProgram:Int) -> [Payment_NotCoreData]{
        
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var monthsUntilRepayment : Int = loan.monthsUntilRepayment.integerValue
        var balance = loan.balance.doubleValue
        var rate = (loan.interest.doubleValue / 12 ) / 100
        var excessInterest : Double = 0
        var monthlyStandardPayment = self.getAllEligibleLoansPayment(isIBR) //monthly
        var newBalance : Double = balance
        
        
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
            else {
                var proRataStandardPayment = loan.getStandardMonthlyPayment(120-year*12, balance: newBalance)
                
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
        return paymentArrayToReturn
        
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
        let percentOfDiscretionaryIncomeForEachMonth = percentOfDiscretionaryIncome / 12
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
