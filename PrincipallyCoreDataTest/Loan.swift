//
//  Loan.swift
//  
//
//  Created by Rebecca Maurer on 5/31/15.
//
//

import Foundation
import CoreData


class Loan: NSManagedObject {

    //TODO: institute rounding at various stages 
    
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
    @NSManaged var defaultTotalLoanInterest: NSNumber
    @NSManaged var defaultTotalLoanMonths: NSNumber
    @NSManaged var nnewTotalLoanInterest: NSNumber
    @NSManaged var nnewTotalLoanMonths: NSNumber
    
    //can be deleted
    func copySelfToNewLoan(nnewLoan:Loan, managedObjectContext:NSManagedObjectContext) {
        let oldLoan = self
        nnewLoan.name = oldLoan.name
        nnewLoan.interest = oldLoan.interest
        nnewLoan.balance = oldLoan.balance
        nnewLoan.loanType = oldLoan.loanType
        nnewLoan.defaultMonthlyPayment = oldLoan.defaultMonthlyPayment
        nnewLoan.monthsInRepaymentTerm = oldLoan.monthsInRepaymentTerm
        nnewLoan.monthsUntilRepayment = oldLoan.monthsUntilRepayment
        nnewLoan.defaultTotalLoanMonths = oldLoan.defaultTotalLoanMonths
        nnewLoan.defaultTotalLoanInterest = oldLoan.defaultTotalLoanInterest
        
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        let oldLoanMP = self.mpForOneLoan.mutableCopy() as! NSOrderedSet
        var nnewLoanMP = nnewLoan.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        
        for payment in oldLoanMP {
            var oldPayment = payment as! MonthlyPayment
            var nnewPayment = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            nnewPayment.principal = oldPayment.principal
            nnewPayment.interest = oldPayment.interest
            nnewPayment.totalPayment = oldPayment.totalPayment
            nnewLoanMP.addObject(nnewPayment)
        }
        
        nnewLoan.mpForOneLoan = nnewLoanMP.copy() as! NSOrderedSet
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }
    
    func refi_WindUpLoan(interest:Double, increaseInInterest:Double, refinanceTerm:Int) -> [Payment_NotCoreData]{
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var numberOfInterestIncreases = Int(increaseInInterest)
        var totalMonths = refinanceTerm * 12
        var balance = self.balance.doubleValue
        var rate = (self.interest.doubleValue / 12 ) / 100
        var monthlyPayment = self.getStandardMonthlyPayment(totalMonths, balance: self.balance.doubleValue)
        var monthsLeftInTerm :Int = totalMonths
        
        if refinanceTerm > numberOfInterestIncreases {
            println("refinance term is greater than the number of interest increases")
            while numberOfInterestIncreases > 0 {
                for month in 1...12{
                    println(monthsLeftInTerm)
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = balance * rate
                    paymentToAdd.principal = monthlyPayment - (balance * rate)
                    paymentToAdd.total = monthlyPayment
                    balance = balance - paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                    monthsLeftInTerm = monthsLeftInTerm - 1
            }
                self.interest = self.interest.doubleValue + 1
                println(self.interest)
                rate = (self.interest.doubleValue / 12 ) / 100
                numberOfInterestIncreases -= 1
                monthlyPayment = self.getStandardMonthlyPayment(monthsLeftInTerm, balance: balance)
            }
        }
        else {
            //handling where the increase is greater than the repayment term
            while numberOfInterestIncreases > 0 {
                for month in 1...12{
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = balance * rate
                    paymentToAdd.principal = monthlyPayment - (balance * rate)
                    paymentToAdd.total = monthlyPayment
                    balance = balance - paymentToAdd.principal
                    paymentArrayToReturn.append(paymentToAdd)
                    monthsLeftInTerm = monthsLeftInTerm - 1
                }
                self.interest = self.interest.doubleValue + 2
                rate = (self.interest.doubleValue / 12 ) / 100
                numberOfInterestIncreases -= 2
                monthlyPayment = self.getStandardMonthlyPayment(monthsLeftInTerm, balance: balance)

        }
        }
        //now we are out of the increases and can
        while balance > monthlyPayment {
            var paymentToAdd = Payment_NotCoreData()
            paymentToAdd.interest = balance * rate
            paymentToAdd.principal = monthlyPayment - (balance * rate)
            paymentToAdd.total = monthlyPayment
            balance = balance - paymentToAdd.principal
            paymentArrayToReturn.append(paymentToAdd)
            println(self.interest)
        }
        
        var lastPaymentToAdd = Payment_NotCoreData()
        lastPaymentToAdd.interest = balance * rate
        lastPaymentToAdd.principal = balance
        lastPaymentToAdd.total = balance + (balance * rate)
        paymentArrayToReturn.append(lastPaymentToAdd)
        
        return paymentArrayToReturn
        
    }
        
    
    func standardFlat_WindUpLoan(paymentTerm:Int) -> [Payment_NotCoreData] {
        var totalMonths = paymentTerm + self.monthsUntilRepayment.integerValue
        var monthlyPayment = self.getStandardMonthlyPayment(minElement([totalMonths,paymentTerm]), balance: self.balance.doubleValue)
        var balance = self.balance.doubleValue + self.capitalizedInterest()
        var rate = (self.interest.doubleValue / 12) / 100
        var paymentArrayToReturn = [Payment_NotCoreData]()
        var monthsUntilRepayment = self.monthsUntilRepayment.integerValue
        
        while monthsUntilRepayment > 0 {
            var paymentToAdd = Payment_NotCoreData()
            paymentArrayToReturn.append(paymentToAdd)
            monthsUntilRepayment -= 1
        }
        
        while balance > monthlyPayment {
            var paymentToAdd = Payment_NotCoreData()
            paymentToAdd.interest = balance * rate
            paymentToAdd.principal = monthlyPayment - (balance * rate)
            paymentToAdd.total = monthlyPayment
            balance = balance - paymentToAdd.principal
            paymentArrayToReturn.append(paymentToAdd)
        }
        
        var lastPaymentToAdd = Payment_NotCoreData()
        lastPaymentToAdd.interest = balance * rate
        lastPaymentToAdd.principal = balance
        lastPaymentToAdd.total = balance + (balance * rate)
        paymentArrayToReturn.append(lastPaymentToAdd)
        
        return paymentArrayToReturn
    }
    
    
    

    func getStandardMonthlyPayment (term:Int, balance:Double) -> Double {
        let r = (self.interest.doubleValue / 100) / 12 //monthly repayment -- divide by 100 to convert from percent to decimal.  divide by 12 to get monthly from annual rate.
        let PV = balance
        
        //Check if payment has already started.  In which case, calculate the repayment amount based on the total number of months on the loan 
        
        if self.monthsUntilRepayment.integerValue <= 0 {
            let n = Double(term + self.monthsUntilRepayment.integerValue) * -1 //we add the months until repayment because it's a negative number if the loan has already entered repayment.  we only make it negative again for the purposes of the forumula
            let defaultMonthlyPayment = (r * PV) / (1 - pow((1+r),n))
            return defaultMonthlyPayment
        }
        
        //otherwise payment hasn't started and we need to check if interest is accruing
        else{
            let n = Double(term * -1)
            if self.loanType == "Direct Stafford - Subsidized" || self.loanType ==  "Perkins" { //interest doesn't accrue. You can just calculate the repayment amount straight away
                let defaultMonthlyPayment = (r * PV) / (1 - pow((1+r),n))
                return defaultMonthlyPayment
            }else{
                let extraInterest = (r * self.monthsUntilRepayment.doubleValue) * PV //this interest doesn't capitalize until repayment begins, so need to do compound interest formulat
                let extraPV = PV + extraInterest
                let defaultMonthlyPayment = (r * extraPV) / (1 - pow((1+r),n))
                return defaultMonthlyPayment
            }
            
        }
    }
    
    //This can be run on any loan and will return the amount of interest that will be capitalized when the loan enters repayment.  It takes into account the loan type and will return 0 if either the loan is subsidized or if the loan is already in repayment
    func capitalizedInterest() -> Double {
        if self.loanType == "Direct Stafford - Subsidized" || self.loanType ==  "Perkins" { //interest doesn't accrue. You can just return nothing
            return 0
        }else{
            var rate = (self.interest.doubleValue / 12) / 100
            if self.monthsUntilRepayment.doubleValue > 0 {
                let extraInterest = (rate * self.monthsUntilRepayment.doubleValue) * self.balance.doubleValue //this interest doesn't capitalize until repayment begins, so need to do compound interest formula
                return extraInterest
            }
            else{
                return 0
            }
        }
    }
    
    func capitalizedOneMonthOfInterest(balance:Double) -> Double {
        if self.loanType == "Direct Stafford - Subsidized" || self.loanType ==  "Perkins" { //interest doesn't accrue. You can just return nothing
            return 0
        }else{
            var rate = (self.interest.doubleValue / 12) / 100
            let extraInterest = balance * rate
            return extraInterest
        }
        
    }
    
    class OnTheFlyMonthlyPayment {
         var principal: NSNumber = 0
         var interest: NSNumber = 0
         var totalPayment: NSNumber = 0
         var paymentIndex: NSNumber = 0
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
    
    func getMonthsUntilRepayment(month:String, year:String) -> Int {
        let startYear = NSNumberFormatter().numberFromString(year)!.integerValue
        let startMonth = convertMonthNameToNumer(month)
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: now)
        let nowYear = components.year
        let nowMonth = components.month
        
        let yearDiffInMonths = (startYear - nowYear) * 12
        let monthDiff = (startMonth - nowMonth)
        let monthsUntilRepayment = yearDiffInMonths + monthDiff
        
        //For example, if it's currently 6 / 2015, and payment starts in 3 / 2016 that should be positive 9 months.  2016 - 2015 = 1, 12. then 3 - 6 = -3 and 12 + -3 is 9 
        return monthsUntilRepayment
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
    
    func enterLoanByDate (managedObjectContext : NSManagedObjectContext) {
    }
    
    //can be deleted -- but should be moved over to Scenario, perhaps
    func getTotalInterestForLoansMP()-> Double {
        var totalInterest : Double = 0
        for payment in self.mpForOneLoan {
            var payment = payment as! MonthlyPayment
            totalInterest += payment.interest.doubleValue
        }
        return totalInterest
    }
    
    //toDelete
    func enteredLoanByPayment(managedObjectContext:NSManagedObjectContext){
            }
    
    
    //toDelete
    func deleteLoanFromDefaultScenario(managedObjectContext:NSManagedObjectContext) {
        //TODO: when you subtract the MP and it goes down to 0, you need to delete the mpEntirely. 
        var defaultScenario: Scenario! = getDefault(managedObjectContext)
        var mpForAllLoans = defaultScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        var mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        var totalMonths = mpForThisLoan.count - 1
        var totalInterest = defaultScenario.interestOverLife.doubleValue
        for month in 0...totalMonths{
            var currentMonth = mpForAllLoans[month] as! MonthlyPayment
            var toBeSubtractedMonth = mpForThisLoan[month] as! MonthlyPayment
            currentMonth.subtractAnotherMP(toBeSubtractedMonth)
            if currentMonth.totalPayment.doubleValue == 0 {
                managedObjectContext.deleteObject(currentMonth as NSManagedObject)
            }
            totalInterest = totalInterest - toBeSubtractedMonth.interest.doubleValue
        }
        var error: NSError?
        defaultScenario.interestOverLife = totalInterest
        defaultScenario.defaultTotalScenarioInterest = totalInterest
        defaultScenario.defaultScenarioMaxPayment = defaultScenario.getScenarioMaxPayment()
        defaultScenario.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
        defaultScenario.defaultTotalScenarioMonths = mpForAllLoans.count
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        //ToDo: is this deleting correctly?  What about making a a funcion that updates all the other scenarios with the new defaults? No -- should probably just warn that the 
    }
    
    //toDelete
    func getTotalInterest(mpForThisLoan : NSMutableOrderedSet) -> Double {
        var totalInterest :Double = 0
        for month in mpForThisLoan {
            var month = month as! MonthlyPayment
            totalInterest += month.interest.doubleValue
        }
        return totalInterest
    }

    func standardFlat_ExtraPayment_WindUpLoan(managedObjectContext:NSManagedObjectContext,extraAmount:Double, extraStart:Int, extraEnd:Int, paymentTerm:Int) -> (parray: [Payment_NotCoreData], monthNumber: Int, description:String) {
        println("extrapayment was called")
        println(self.name)
        println(self.monthsUntilRepayment.integerValue)
        println(extraAmount)
        println(extraStart)
        println(extraEnd)
        
        
        var monthlyPayment = self.getStandardMonthlyPayment(paymentTerm, balance: self.balance.doubleValue)
        //var mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        //var balance = self.balance.doubleValue + self.capitalizedInterest()
        //we add on the capitalized interest (if any) from the beginning.  note that this will have to be changed in secnarios 2 and 3
        var rate = (self.interest.doubleValue / 12) / 100
        var error: NSError?
        var newExtraEnd : Int = extraEnd
        var standardPayments = self.standardFlat_WindUpLoan(paymentTerm)
        var newPaymentsArray = [Payment_NotCoreData]()
     
        //Scenario 1 loan enters repayment before hte extra payments are added
        if self.monthsUntilRepayment.integerValue <= extraStart {
            var balance = self.balance.doubleValue + self.capitalizedInterest()
            //Step 1: copy over old payments until the extras start
            if extraStart > 0 {
                for index in 0...extraStart-1 {
                    newPaymentsArray.append(standardPayments[index])
                    balance = balance - standardPayments[index].principal
                }
            }
            
            //Step 2: handle the range of extraStart to extraEnd, keeping in mind that the entire loan may potentially be paid off during this window, in which case we need to change the
            for index in extraStart...extraEnd{
                var mpForThisMonth = Payment_NotCoreData()
                //2.1: make sure there's enough balance left for the full payment
                if balance > (monthlyPayment + extraAmount) {
                    mpForThisMonth.total = monthlyPayment + extraAmount
                    mpForThisMonth.interest = balance * rate
                    mpForThisMonth.principal = mpForThisMonth.total - mpForThisMonth.interest
                    balance = balance - mpForThisMonth.principal
                    newPaymentsArray.append(mpForThisMonth)
                } else {
                    //there's still extra payments to be made, so we adjust the ExtraEnd
                    newExtraEnd = index
                    break
                }
                
            }
            
            //Step 3: deal with the remaining loan balance
            while balance > monthlyPayment {
                var paymentToAdd = Payment_NotCoreData()
                paymentToAdd.interest = balance * rate
                paymentToAdd.principal = monthlyPayment - (balance * rate)
                paymentToAdd.total = monthlyPayment
                balance = balance - paymentToAdd.principal
                newPaymentsArray.append(paymentToAdd)
            }
            
            var lastPaymentToAdd = Payment_NotCoreData()
            lastPaymentToAdd.interest = balance * rate
            lastPaymentToAdd.principal = balance
            lastPaymentToAdd.total = balance + (balance * rate)
            newPaymentsArray.append(lastPaymentToAdd)
        }
        //Scenario 2 all extra payments are made before loan enters repayent
        else if self.monthsUntilRepayment.integerValue > extraEnd {
            //start with original balance with no added interest
            var balance = self.balance.doubleValue
            var interestThatWillBeCapitalized :Double = 0
            //these are all going to be 0 payments.  add any interes tif needed
            if extraStart > 0 {
                for index in 0...extraStart-1 {
                    newPaymentsArray.append(standardPayments[index])
                    interestThatWillBeCapitalized += self.capitalizedOneMonthOfInterest(balance)
                    //balance = balance
                }
            }
            //these are all going to be Extra_Amount_Only
            for index in extraStart...extraEnd{
                var mpForThisMonth = Payment_NotCoreData()
                //2.1: make sure there's enough balance left for the full payment
                if (balance + interestThatWillBeCapitalized) > extraAmount {
                    //starthere: you need to have it pay off accrued interest first. 
                    if interestThatWillBeCapitalized > extraAmount {
                         mpForThisMonth.total = extraAmount
                         mpForThisMonth.interest = extraAmount
                         mpForThisMonth.principal = 0
                         interestThatWillBeCapitalized = interestThatWillBeCapitalized - extraAmount + self.capitalizedOneMonthOfInterest(balance)
                        newPaymentsArray.append(mpForThisMonth)
                    }
                    else if interestThatWillBeCapitalized < extraAmount && interestThatWillBeCapitalized > 0 {//this is the mixed interest / principal payment.  there will only ever be one of these.
                    mpForThisMonth.total = extraAmount
                    mpForThisMonth.interest = interestThatWillBeCapitalized
                    mpForThisMonth.principal = mpForThisMonth.total - mpForThisMonth.interest
                    balance = balance - mpForThisMonth.principal
                    interestThatWillBeCapitalized = 0
                    newPaymentsArray.append(mpForThisMonth)
                    }
                    
                    else {
                        //now we are making extra payments that are standard.
                        mpForThisMonth.total = extraAmount
                        mpForThisMonth.interest = self.capitalizedOneMonthOfInterest(balance)
                        mpForThisMonth.principal = mpForThisMonth.total - mpForThisMonth.interest
                        balance = balance - mpForThisMonth.principal
                        interestThatWillBeCapitalized = 0
                        newPaymentsArray.append(mpForThisMonth)
                    }
                } else {
                    //use the extra payment to pay off the loan completely.  Here is an assumption that could lead to un-optimized paybacks.  For instance, if you are paying 1000 extra each month, and have 50 left in the balance, this will have you use the last "extra" payment to pay off the loan.  however, i'm not keeping track of that remaining 950
                    var lastPaymentToAdd = Payment_NotCoreData()
                    lastPaymentToAdd.interest = balance * rate
                    lastPaymentToAdd.principal = balance
                    lastPaymentToAdd.total = balance + (balance * rate)
                    balance = 0
                    interestThatWillBeCapitalized = 0
                    newPaymentsArray.append(lastPaymentToAdd)
                    //there's still extra payments to be made, so we adjust the ExtraEnd
                    newExtraEnd = index + 1
                    break
                }
                
            }
            
            balance += interestThatWillBeCapitalized
            
            if balance > 0 {
                let newMonthlyPayment = self.getStandardMonthlyPayment(paymentTerm, balance:balance)
                if self.monthsUntilRepayment.integerValue-1 > extraEnd+1 {
                    for index in extraEnd+1...self.monthsUntilRepayment.integerValue-1 {
                    //remember, the assumption here is that all payments are pre-repayment, so we can append 0/0/0 blanks
                        newPaymentsArray.append(Payment_NotCoreData())
                        balance = balance + self.capitalizedOneMonthOfInterest(balance)
                    }
                }
                
                while balance > monthlyPayment {
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = balance * rate
                    paymentToAdd.principal = monthlyPayment - (balance * rate)
                    paymentToAdd.total = monthlyPayment
                    balance = balance - paymentToAdd.principal
                    newPaymentsArray.append(paymentToAdd)
                }
                
                var lastPaymentToAdd = Payment_NotCoreData()
                lastPaymentToAdd.interest = balance * rate
                lastPaymentToAdd.principal = balance
                lastPaymentToAdd.total = balance + (balance * rate)
                newPaymentsArray.append(lastPaymentToAdd)
            }
        }
        //Scenario 3 MUR is between start and end.
        else {
            //Scenario 3 MUR is between start and end.
            var balance = self.balance.doubleValue
            var interestThatWillBeCapitalized :Double = 0
            //Step 1: copy over old payments until the extras start
            if extraStart > 0 {
                for index in 0...extraStart-1 {
                    newPaymentsArray.append(standardPayments[index])
                    balance = balance - standardPayments[index].principal
                    interestThatWillBeCapitalized += self.capitalizedOneMonthOfInterest(balance)
                }
            }
            //step 2
            for index in extraStart...self.monthsUntilRepayment.integerValue-1{
                var mpForThisMonth = Payment_NotCoreData()
                //2.1: make sure there's enough balance left for the full payment
                if (balance + interestThatWillBeCapitalized) > extraAmount {
                    //starthere: you need to have it pay off accrued interest first.
                    if interestThatWillBeCapitalized > extraAmount {
                        mpForThisMonth.total = extraAmount
                        mpForThisMonth.interest = extraAmount
                        mpForThisMonth.principal = 0
                        interestThatWillBeCapitalized = interestThatWillBeCapitalized - extraAmount + self.capitalizedOneMonthOfInterest(balance)
                        newPaymentsArray.append(mpForThisMonth)
                    }
                    else if interestThatWillBeCapitalized < extraAmount && interestThatWillBeCapitalized > 0 {//this is the mixed interest / principal payment
                        mpForThisMonth.total = extraAmount
                        mpForThisMonth.interest = interestThatWillBeCapitalized
                        mpForThisMonth.principal = mpForThisMonth.total - mpForThisMonth.interest
                        balance = balance - mpForThisMonth.principal
                        interestThatWillBeCapitalized = 0
                        newPaymentsArray.append(mpForThisMonth)
                    }
                        
                    else {
                        //now we are making extra payments that are standard.
                        mpForThisMonth.total = extraAmount
                        mpForThisMonth.interest = self.capitalizedOneMonthOfInterest(balance)
                        mpForThisMonth.principal = mpForThisMonth.total - mpForThisMonth.interest
                        balance = balance - mpForThisMonth.principal
                        interestThatWillBeCapitalized = 0
                        newPaymentsArray.append(mpForThisMonth)
                    }
                } else {
                    var lastPaymentToAdd = Payment_NotCoreData()
                    lastPaymentToAdd.interest = balance * rate
                    lastPaymentToAdd.principal = balance
                    lastPaymentToAdd.total = balance + (balance * rate)
                    balance = 0
                    newPaymentsArray.append(lastPaymentToAdd)
                    //there's still extra payments to be made, so we adjust the ExtraEnd
                    newExtraEnd = index + 1
                    break
                }

            }
            
            balance += interestThatWillBeCapitalized
            
            for index in self.monthsUntilRepayment.integerValue...extraEnd{
                let newMonthlyPayment = self.getStandardMonthlyPayment(paymentTerm, balance:balance)
                if balance > 0 {
                    var mpForThisMonth = Payment_NotCoreData()
                    //2.1: make sure there's enough balance left for the full payment
                    if balance > (newMonthlyPayment + extraAmount) {
                        mpForThisMonth.total = newMonthlyPayment + extraAmount
                        mpForThisMonth.interest = balance * rate
                        mpForThisMonth.principal = mpForThisMonth.total - mpForThisMonth.interest
                        balance = balance - mpForThisMonth.principal
                        newPaymentsArray.append(mpForThisMonth)
                    } else {
                        //there's still extra payments to be made, so we adjust the ExtraEnd
                        newExtraEnd = index
                        break
                    }
                    
                }
                }
            
            if balance > 0 {
                while balance > monthlyPayment {
                    var paymentToAdd = Payment_NotCoreData()
                    paymentToAdd.interest = balance * rate
                    paymentToAdd.principal = monthlyPayment - (balance * rate)
                    paymentToAdd.total = monthlyPayment
                    balance = balance - paymentToAdd.principal
                    newPaymentsArray.append(paymentToAdd)
                }
                
                var lastPaymentToAdd = Payment_NotCoreData()
                lastPaymentToAdd.interest = balance * rate
                lastPaymentToAdd.principal = balance
                lastPaymentToAdd.total = balance + (balance * rate)
                newPaymentsArray.append(lastPaymentToAdd)

            }
        }

        let numberOfExtraPaymentMonths = newExtraEnd //- extraStart
        
        let description : String! = "\(numberOfExtraPaymentMonths) suppelemental payments were made on \(self.name), which has an interest rate of %\(self.interest)"
    
        return (newPaymentsArray, newExtraEnd, description)
    }
    
    
    func makeStringOfPayments() -> NSAttributedString {
        var ps = String()
        let mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForThisLoan{
            let payment = payment as! MonthlyPayment
            var toBeAdded:String = "Total Payment: " + payment.totalPayment.stringValue
            var toBeAdded2:String = " and Principal" + payment.principal.stringValue + "\n"
            ps = ps + toBeAdded + toBeAdded2
        }
        var myMutableString = NSMutableAttributedString(string: ps)
        return myMutableString
    }
    
    func makeStringOfAllPayments(managedObjectContext:NSManagedObjectContext) -> NSAttributedString {
        var ps = String()
        var defaultScenario: Scenario! = getDefault(managedObjectContext)
        var mpForAllLoans = defaultScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForAllLoans{
            let payment = payment as! MonthlyPayment
            var toBeAdded:String = "Total Payment: " + payment.totalPayment.stringValue
            var toBeAdded2:String = " and Principal" + payment.principal.stringValue + "\n"
            ps = ps + toBeAdded + toBeAdded2
        }
        var myMutableString = NSMutableAttributedString(string: ps)
        return myMutableString
    }
    
    func makeArrayOfAllPrincipalPayments() -> [Double]{
        var arrayOfAllPrincipalPayments = [Double]()
        var mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForThisLoan{
            let payment = payment as! MonthlyPayment
            arrayOfAllPrincipalPayments.append(payment.principal.doubleValue)
        }
        return arrayOfAllPrincipalPayments
    }
    
    func makeArrayOfAllInterestPayments() -> [Double]{
        var arrayOfAllPrincipalPayments = [Double]()
        var mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForThisLoan{
            let payment = payment as! MonthlyPayment
            let roundpayment = round(payment.interest.doubleValue * 100) / 100
            arrayOfAllPrincipalPayments.append(roundpayment)
        }
        return arrayOfAllPrincipalPayments
    }
    
    func makeArrayOfAllTotalPayments() -> [Double]{
        var arrayOfAllPrincipalPayments = [Double]()
        var mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForThisLoan{
            let payment = payment as! MonthlyPayment
            let roundpayment = round(payment.totalPayment.doubleValue * 100) / 100
            arrayOfAllPrincipalPayments.append(roundpayment)
        }
        return arrayOfAllPrincipalPayments
    }

    
    
}//end of the class













