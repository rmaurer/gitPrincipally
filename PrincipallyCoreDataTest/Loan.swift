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

    func getDefaultMonthlyPayment (monthsUntilRepayment: Int) -> Double {
        let r = (self.interest.doubleValue / 100) / 12 //monthly repayment -- divide by 100 to convert from percent to decimal.  divide by 12 to get monthly from annual rate.
        let PV = self.balance.doubleValue
        
        //Check if payment has already started.  In which case, calculate the repayment amount based on the total number of months on the loan 
        if monthsUntilRepayment <= 0 {
            let n = Double(self.monthsInRepaymentTerm.integerValue * -1) //Make it negative for purposes of the formula
            let defaultMonthlyPayment = (r * PV) / (1 - pow((1+r),n))
            return defaultMonthlyPayment
        }
        
        //otherwise payment hasn't started and we need to check if interest is accruing
        else{
            let n = self.monthsInRepaymentTerm.doubleValue * -1
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
    
    func getStringOfYearAndMonthForPaymentNumber(mpNumber:Double) -> String{
        let now = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: now)
        let nowYear = components.year
        let nowMonth = components.month
        var returnYear : Int = 0
        var returnMonth : Int = 0
        let yearsToAdd = floor(mpNumber / 12)
        let monthsToAdd = mpNumber % 12
        println("year to add \(yearsToAdd)")
        println("month to add \(monthsToAdd)")
        
        if nowMonth + Int(monthsToAdd) > 12 {
            returnYear = nowYear + Int(yearsToAdd) + 1
            returnMonth = nowMonth + Int(monthsToAdd) - 12
        } else{
            returnYear = nowYear + Int(yearsToAdd)
            returnMonth = nowMonth + Int(monthsToAdd)
            println("should get in here")
            println(returnYear)
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
    
    //this function pulls out the information on the loan, finds if there's a Scenario already called "Default", adds any MPs necessary based on the length of hte repayment of the loan.  Then it loads up the MPs with the new payments.  Extra here is deprecated, so just always set to 0 when calling this.
    func enterLoanByDate (managedObjectContext : NSManagedObjectContext) {
        //set default monthly payment, which accounts for whether payment has already started or not
        self.defaultMonthlyPayment = NSNumber(double:self.getDefaultMonthlyPayment(self.monthsUntilRepayment.integerValue))
        var monthlyPayment = self.defaultMonthlyPayment.doubleValue
        var balance = self.balance.doubleValue + self.capitalizedInterest()
        var rate = (self.interest.doubleValue / 12) / 100
        var totalMonths = self.monthsUntilRepayment.integerValue + self.monthsInRepaymentTerm.integerValue
        //Pull up Monthly Payment Entity
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        //Pull up scenario Entity, check whether there's already a default entity
        var defaultScenario: Scenario! = getDefault(managedObjectContext)
        //not saving the total Interest var so that the interest adds up.  am I not inserting this into managedObjectContext
        var totalInterest = defaultScenario.interestOverLife as! Double

        //build the set of monthly payments for this loan
        let mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        
        //get the concatenatedpayment for the default monthly payment scenario
        let mpForAllLoans = defaultScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        //add blank Monthly Payments for the total length.
        while mpForAllLoans.count < totalMonths {
            var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                monthlyPaymentToBeAdded.interest = 0//balance * rate
                monthlyPaymentToBeAdded.principal = 0//monthlyPayment - (balance * rate)
                monthlyPaymentToBeAdded.totalPayment = 0//monthlyPayment
                mpForAllLoans.addObject(monthlyPaymentToBeAdded)
            }
        //if payments going to start in 9 months, then the months until repayment is positive 9. Let's say it's a 10 year term after that.  That's 129 total months.  Index will start at 9, and then go 8, 7, 6, 5, 4, 3, 2, 1, 0[start payment], -1 [in payment], -2 [in payment], etc. etc. Meanwhile in the mpForThisLoan, the index values will go 0, 1, 2, 3, 4, 5, 6, 7, 8, 9[start payment], 10 [ in payment], 11 [ in payment, etc. etc.]
        
            var index = self.monthsUntilRepayment.integerValue
            for mpPayment in mpForAllLoans {
                let mpPayment = mpPayment as! MonthlyPayment
                if index <= 0 { //if loan is already in repayment or just starting
                    if balance > monthlyPayment {
                        //and if it's not the last payment, add relevant values to the concatenated MP
                        mpPayment.principal = mpPayment.principal.doubleValue + monthlyPayment - (balance * rate)
                        mpPayment.interest = mpPayment.interest.doubleValue + (balance * rate)
                        //println(" \(index): interest \(mpPayment.interest)")
                        mpPayment.totalPayment = mpPayment.totalPayment.doubleValue + monthlyPayment
                        //now add a MP to the mpForThisLoan.
                        var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                        monthlyPaymentToBeAdded.addPayment(monthlyPayment,balance:balance, rate:rate)
                        mpForThisLoan.addObject(monthlyPaymentToBeAdded)
                        //to finish out the loop, add to total interest, and subtract from balance
                        totalInterest += balance * rate
                        balance = balance + (balance * rate) - monthlyPayment
                        
                    }else if balance > 0 {//last payment
                        mpPayment.addFinalPayment(balance, rate:rate)
                        //add to the MP for this loan
                        var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                        monthlyPaymentToBeAdded.addFinalPayment(balance, rate:rate)
                        mpForThisLoan.addObject(monthlyPaymentToBeAdded)
                        //finish out the loop.
                        totalInterest += balance * rate
                        balance = 0
                    }
                }else{ // if it's not in repayment yet, do nothing, and decrease the index, but add a monthly payment to to the MPForThisLoan
                    index = index - 1
                    var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                    monthlyPaymentToBeAdded.interest = 0
                    monthlyPaymentToBeAdded.principal = 0
                    monthlyPaymentToBeAdded.totalPayment = 0
                    mpForThisLoan.addObject(monthlyPaymentToBeAdded)
                }
              
            }
        //save
        var error: NSError?
        self.mpForOneLoan = mpForThisLoan.copy() as! NSOrderedSet
        defaultScenario.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
        defaultScenario.interestOverLife = totalInterest
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }
    
    func enteredLoanByPayment(managedObjectContext:NSManagedObjectContext){
        var monthlyPayment = self.defaultMonthlyPayment.doubleValue
        var balance = self.balance.doubleValue + self.capitalizedInterest()
        var rate = (self.interest.doubleValue / 12) / 100
        var defaultScenario: Scenario! = getDefault(managedObjectContext)
        var totalInterest = defaultScenario.interestOverLife as! Double
        var months: Int = 0
        let mpForAllLoans = defaultScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        let mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        //if payments going to start in 9 months, then the months until repayment is positive 9
        //first go through all of the mps already in the scenario. First check to make sure there's still balance on the loan left, and if we are at the last payment, enter that instead.  All the while add on to months variable.  only enter "else" once so that months doesn't keep going up.  If we get through all the MPs already in teh scenario, we then turn to adding more MPs as we go along, and again go through them normally then add a last and final one.
        for mpPayment in mpForAllLoans{
            let mpPayment = mpPayment as! MonthlyPayment
            if balance > monthlyPayment {
                //add to all loans
                mpPayment.addPayment(monthlyPayment,balance:balance, rate:rate)
                //add to this loan's MP
                var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                monthlyPaymentToBeAdded.addPayment(monthlyPayment,balance:balance, rate:rate)
                mpForThisLoan.addObject(monthlyPaymentToBeAdded)
                //wind up interest, and chance balance
                totalInterest += balance * rate
                balance = balance + (balance * rate) - monthlyPayment
                months = months + 1
            } else if balance > 0 {
                //add to all loans
                mpPayment.addFinalPayment(balance, rate:rate)
                //add to this loan's MP
                var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                monthlyPaymentToBeAdded.addFinalPayment(balance, rate:rate)
                mpForThisLoan.addObject(monthlyPaymentToBeAdded)
                //change balance
                totalInterest += balance * rate
                months = months + 1
                balance = 0
            }
        }
       //now if there's not any more MP's in the concatenated MPs, we keep going through this loan, adding MPs to the total MP and this loan's MP as we go along
        while balance > monthlyPayment {
            //all loans
            var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            monthlyPaymentToBeAdded.addPayment(monthlyPayment,balance:balance, rate:rate)
            mpForAllLoans.addObject(monthlyPaymentToBeAdded)
            //this loan
            var monthlyPaymentToBeAddedToThisLoan = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            monthlyPaymentToBeAddedToThisLoan.addPayment(monthlyPayment,balance:balance, rate:rate)
            mpForThisLoan.addObject(monthlyPaymentToBeAddedToThisLoan)
            //change balance
            totalInterest += balance * rate
            balance = balance + (balance * rate) - monthlyPayment
            months = months + 1
        }
        if balance > 0 { //just double check to make sure there's still a final payment to be added and that it wasn't finished in the for loop above
            //add last payment for all loans
            var lastMonthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            lastMonthlyPaymentToBeAdded.addFinalPayment(balance, rate:rate)
            mpForAllLoans.addObject(lastMonthlyPaymentToBeAdded)
            //add last payment for this loan
            var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            monthlyPaymentToBeAdded.addFinalPayment(balance, rate:rate)
            mpForThisLoan.addObject(monthlyPaymentToBeAdded)
            months = months + 1
            totalInterest += balance * rate
        }
        //save
        var error: NSError?
        self.mpForOneLoan = mpForThisLoan.copy() as! NSOrderedSet
        defaultScenario.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
        defaultScenario.interestOverLife = totalInterest
        self.monthsInRepaymentTerm = months
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }
    
    func deleteLoanFromDefaultScenario(managedObjectContext:NSManagedObjectContext) {
        var defaultScenario: Scenario! = getDefault(managedObjectContext)
        var mpForAllLoans = defaultScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        var mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        var totalMonths = self.monthsUntilRepayment.integerValue + self.monthsInRepaymentTerm.integerValue - 1
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
        defaultScenario.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }        
    }
    
    func addLoanToCurrentScenario(managedObjectContext:NSManagedObjectContext, currentScenario:Scenario) {
        var mpForAllLoans = currentScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        var mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        var totalMonths = self.monthsUntilRepayment.integerValue + self.monthsInRepaymentTerm.integerValue - 1
        var totalInterest = currentScenario.interestOverLife.doubleValue
        println("addLoan is being called with loan \(self.name) with interest rate \(self.interest) and time frame \(totalMonths)")
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        //make sure there's enough MPs in the MpForAllLoans
        while mpForThisLoan.count > mpForAllLoans.count{
            var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            monthlyPaymentToBeAdded.interest = 0
            monthlyPaymentToBeAdded.principal = 0
            monthlyPaymentToBeAdded.totalPayment = 0
            mpForAllLoans.addObject(monthlyPaymentToBeAdded)
        }
        for month in 0...mpForThisLoan.count - 1{
            var currentMonth = mpForAllLoans[month] as! MonthlyPayment
            var toBeAddedMonth = mpForThisLoan[month] as! MonthlyPayment
            currentMonth.addAnotherMP(toBeAddedMonth)
            println("there was\(toBeAddedMonth.interest) in interest addded to payment number \(month) from loan number \(self.name) in the 'add all payments withoutextra' function")
            totalInterest = totalInterest + toBeAddedMonth.interest.doubleValue
        }
        var error: NSError?
        currentScenario.interestOverLife = currentScenario.interestOverLife.doubleValue + totalInterest
        currentScenario.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
        //println("we are testing to see if this increases over time")
        //println(currentScenario.interestOverLife)
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }

    func enteredLoanWithExtraPayment(managedObjectContext:NSManagedObjectContext,extra:Double,currentScenario:Scenario,monthsWithExtraPaymentAlready:Int, monthsThatNeedExtraPayment:Int) -> Int {
        
        println("enteredLoanWithExtraPayent is being called with loan \(self.name) with interest rate \(self.interest) and time frame \(monthsWithExtraPaymentAlready)")
        var monthlyPayment = self.defaultMonthlyPayment.doubleValue
        var balance = self.balance.doubleValue + self.capitalizedInterest()
        var rate = (self.interest.doubleValue / 12) / 100
        var totalInterest = currentScenario.interestOverLife as! Double
        var monthsCounter: Int = 0
        
        let mpForAllLoans = currentScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        var mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
        println("here is the monthscounter -- is it rising here? \(mpForAllLoans.count)")
        //if payments going to start in 9 months, then the months until repayment is positive 9
        //first go through all of the mps already in the scenario. The very first thing we need to do is handle the situation where this is the second loan to get the extra payment.  In which case we can only start adding the extra loan after a certain number of other loans have passed.  Then it's the usual check: First check to make sure there's still balance on the loan left, and if we are at the last payment, enter that instead.  All the while add on to months variable.  only enter "else" once so that months doesn't keep going up.  If we get through all the MPs already in teh scenario, we then turn to adding more MPs as we go along, and again go through them normally then add a last and final one.
        for mpPayment in mpForAllLoans{
            if monthsCounter < mpForThisLoan.count{
                var toBeAddedMonth = mpForThisLoan[monthsCounter] as! MonthlyPayment
                mpPayment.addAnotherMP(toBeAddedMonth)
                balance = balance - toBeAddedMonth.principal.doubleValue
                totalInterest = totalInterest + toBeAddedMonth.interest.doubleValue
                monthsCounter = monthsCounter + 1
            }else{
                //if you can add in the whole mpForThisLoan into pre-existing MPs in the concatpayment, then there's nothing else to be done, and no change in the months withExtraPaymentAlready
                var error: NSError?
                currentScenario.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
                currentScenario.interestOverLife =  currentScenario.interestOverLife.doubleValue + totalInterest
                if !managedObjectContext.save(&error) {
                    println("Could not save: \(error)") }
                return monthsCounter
            }
        }
        //now we need to both add new MonthlyPayments and check whether we should be making extra payments
        let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
        //println("got into the rest of the function")
        println("the months counter is \(monthsCounter) and the mpcount is \(mpForThisLoan.count)")
        while monthsCounter < mpForThisLoan.count{
            println("Got into the while loop")
            //if it's not the last payment, and there are still months that need extra payment
            var extraPayment = extra
            if monthsCounter >= monthsThatNeedExtraPayment  {
                extraPayment = 0}
            
            if balance >= (monthlyPayment + extraPayment){
                var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                monthlyPaymentToBeAdded.interest = balance * rate
                println("added another thing")
                println(monthsCounter)
                println(monthlyPaymentToBeAdded.interest)
                monthlyPaymentToBeAdded.principal = monthlyPayment - (balance * rate) + extraPayment
                monthlyPaymentToBeAdded.totalPayment = monthlyPayment + extraPayment
                mpForAllLoans.addObject(monthlyPaymentToBeAdded)
                totalInterest += balance * rate
                balance = balance - monthlyPaymentToBeAdded.principal.doubleValue
                monthsCounter = monthsCounter + 1
            }
            else {
                var lastMonthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                lastMonthlyPaymentToBeAdded.interest = balance * rate
                lastMonthlyPaymentToBeAdded.principal = balance + extraPayment
                lastMonthlyPaymentToBeAdded.totalPayment = balance + (balance * rate) + extraPayment
                mpForAllLoans.addObject(lastMonthlyPaymentToBeAdded)
                totalInterest += balance * rate
                monthsCounter = monthsCounter + 1
                }
            }

        var error: NSError?
        currentScenario.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
        currentScenario.interestOverLife =  currentScenario.interestOverLife.doubleValue + totalInterest
        //println("we are testing to see if this increases over time")
        //println(currentScenario.interestOverLife)
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        
        return monthsCounter //return months in case the loan is paid off faster now.
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

    
    
}//end of the class













