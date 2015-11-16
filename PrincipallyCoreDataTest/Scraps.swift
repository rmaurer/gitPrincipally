//
//  Scraps.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 6/2/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

/* import Foundation

func windUpMonthlyPayments (extra : Double) -> ([OnTheFlyMonthlyPayment]){ //going to be setting the "NSOrderedSet" of monthlypayments
    var pArray = [OnTheFlyMonthlyPayment]()
    var balance = self.balance.doubleValue
    var rate = (self.interest.doubleValue / 12) / 100
    var monthlyPayment = self.defaultMonthlyPayment.doubleValue
    while balance > monthlyPayment {
        var currentPayment = OnTheFlyMonthlyPayment()
        //currentPayment.paymentIndex = i
        currentPayment.interest = balance * rate
        currentPayment.principal = monthlyPayment - (balance * rate)
        currentPayment.totalPayment = monthlyPayment + extra
        pArray.append(currentPayment)
        balance = balance - (monthlyPayment + extra)
    }
    var lastPayment = OnTheFlyMonthlyPayment()
    lastPayment.principal = balance
    lastPayment.interest = balance * rate
    lastPayment.totalPayment = balance + (balance * rate)
    //lastPayment.paymentIndex = i
    pArray.append(lastPayment)
    return pArray
}



func saveMonthlyPaymentArrayToNSOrderedSet (pArray: [OnTheFlyMonthlyPayment], managedObjectContext : NSManagedObjectContext) -> Bool {
    let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
    
    //indeed, you'll have to clear out the existing pArray
    let mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
    if mpForThisLoan.count > 1 {
        println(mpForThisLoan.count)
        println("I'm removing all objects from the NSOrdered set")
        mpForThisLoan.removeAllObjects()
    }
    
    //not we load up the array
    for var i = 0; i < pArray.count; ++i {
        
        //created the new var to be added
        let monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        //copy over the information (is there not a way to do this more efficiently??)
        monthlyPaymentToBeAdded.principal = pArray[i].principal
        monthlyPaymentToBeAdded.interest = pArray[i].interest
        monthlyPaymentToBeAdded.totalPayment = pArray[i].totalPayment
        //monthlyPaymentToBeAdded.paymentIndex = i
        
        //attach it to the current loan's mpArray
        mpForThisLoan.addObject(monthlyPaymentToBeAdded)
        self.mpForOneLoan = mpForThisLoan.copy() as! NSOrderedSet
        
        //save
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        
        
    }
    return true
}


var arrayOfLoans = [NSManagedObject]()

init (arrayOfLoans: [NSManagedObject]){
self.arrayOfLoans = arrayOfLoans
}

func printtest(){
for loan in arrayOfLoans {
var typecastLoan = loan as! Loan
println("\(typecastLoan.name)")
}}

//totalInterest += balance * rate
//balance = balance - monthlyPayment
//push MonthlyPayment
//while balance > monthlyPayment {
//println(monthlyPayment)
// var lastPayment = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
// lastPayment.principal = balance
// lastPayment.interest = balance * rate
// lastPayment.totalPayment = balance + (balance * rate)
// totalInterest += balance * rate
// mpForThisLoan.addObject(lastPayment)
//if it's not the first one, add to hte payment scenarios that already exist



*/

/*   let mpTest = defaultScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
index = 1
for payment in mpTest {
let payment = payment as! MonthlyPayment
println("\(index): totalPayment: \(payment.totalPayment), principal \(payment.principal)")
index = index + 1
}*/

/*

let mpTest = defaultScenario.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
var index = 1
for payment in mpTest {
    let payment = payment as! MonthlyPayment
    println("\(index): totalPayment: \(payment.totalPayment), principal \(payment.principal)")
    index = index + 1 

mpPayment.principal = mpPayment.principal.doubleValue + monthlyPayment - (balance * rate)
mpPayment.interest = mpPayment.interest.doubleValue + (balance * rate)
mpPayment.totalPayment = mpPayment.totalPayment.doubleValue + monthlyPayment


class LoanCalculatorBrains {
var oArray = [NSManagedObject]()

init (oArray: [NSManagedObject]){
self.oArray = oArray
}

func convertArrayOfObjectToArrayOfLoans() -> [Loan]{
var lArray = [Loan]()
for object in self.oArray {
var typecastLoan = object as! Loan
lArray.append(typecastLoan)
//println(typecastLoan.interest)
}
return lArray
}

func printtest(){
for loan in oArray {
var typecastLoan = loan as! Loan
println("\(typecastLoan.name)")
}}


}
let whiteLineDimensions = CGRectMake(30,0,4,CGFloat(rect.height))
whiteLine = UIView(frame:whiteLineDimensions)
whiteLine?.backgroundColor = UIColor.whiteColor()
self.addSubview(whiteLine!)

/*CGContextSetLineWidth(context, 3.0)
CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
CGContextMoveToPoint(context, 30, 0)
CGContextAddLineToPoint(context, 30, CGFloat(rect.height))
CGContextStrokePath(context) */
//animateWithDuration(_:delay:options:animations:completion:)
UIView.animateWithDuration(1, delay: 1, options: nil, animations: {
self.whiteLine!.transform = CGAffineTransformMakeScale(4,4)
}, completion: { finished in
println("Napkins opened!")})

//cd Principally.xcworkspace
//ls-l
//git init principally
//git add --all .
//git status
//git commit -m "another update"

pod 'JBChartView', '~> 2.8.14'
pod 'ChameleonFramework', '~> 1.2.0'
pod 'TextFieldEffects', '~> 0.4'
pod 'FlatUIKit', '~> 1.6'




func makeCALayerWithBorderDeleteAfterTesting(view:UIView, rect:CGRect, color:CGColor) -> CALayer {
    let testLayer = CALayer()
    testLayer.frame = CGRectMake(0,0,rect.width,rect.height)
    testLayer.borderWidth = 20
    testLayer.borderColor = color
    view.layer.addSublayer(testLayer)
    println(view.frame)
    return testLayer
}

for mpPayment in mpForAllLoans{
let mpPayment = mpPayment as! MonthlyPayment

//first, if this is a month where the extra payment was applied elsewhere, just add the loans usual payment into the concat payment
if monthsCounter < monthsWithExtraPaymentAlready{
var toBeAddedMonth = mpForThisLoan[monthsCounter] as! MonthlyPayment
mpPayment.addAnotherMP(toBeAddedMonth)
totalInterest = totalInterest + toBeAddedMonth.interest.doubleValue
monthsCounter = monthsCounter + 1
}

//I feel like this can all be be deleted -- if there's already other concat payments in here, they would be from loans at high interest rates, so
else if balance > (monthlyPayment + extra) {
mpPayment.principal = mpPayment.principal.doubleValue + monthlyPayment - (balance * rate) + extra
mpPayment.interest = mpPayment.interest.doubleValue + (balance * rate)
//println(" \(index): interest \(mpPayment.interest)")
mpPayment.totalPayment = mpPayment.totalPayment.doubleValue + monthlyPayment + extra
totalInterest += balance * rate
balance = balance + (balance * rate) - (monthlyPayment + extra)
months = months + 1
} else if balance > 0 {
mpPayment.principal = mpPayment.principal.doubleValue + balance + extra
mpPayment.interest = mpPayment.interest.doubleValue + (balance * rate)
mpPayment.totalPayment = mpPayment.totalPayment.doubleValue + balance + extra + (balance * rate)
totalInterest += balance * rate
months = months + 1
balance = 0
}
}

println("enteredLoanWithExtraPayent is being called with loan \(self.name) with interest rate \(self.interest) and time frame \(extraStart) to \(extraEnd)")
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
var mpPayment = mpPayment as! MonthlyPayment
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

let mpForAllLoans = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet

while mpForAllLoans.count < maxMonthsInDefaultRepayment{
let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)
var zeroPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
zeroPaymentToBeAdded.interest = 0
zeroPaymentToBeAdded.principal = 0
zeroPaymentToBeAdded.totalPayment = 0
mpForAllLoans.addObject(zeroPaymentToBeAdded)
}
self.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
//println("here's the number of points in the concatpayment")
//println(self.concatenatedPayment.count)
//var error: NSError?

//2 - Create the Fetch Request
let fetchRequest = NSFetchRequest(entityName:"Loan")
//3 - Execute hte Fetch Request
var error: NSError?
let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]

if let results = fetchedResults {
myLoans = results
} else {
println("Could not fetch \(error), \(error!.userInfo)")
}

if self.concatenatedPayment.count > 0 {
for MP in self.concatenatedPayment {
managedObjectContext.deleteObject(MP as! NSManagedObject)
}
}
func enteredLoanByPayment(managedObjectContext:NSManagedObjectContext){
var monthlyPayment = self.defaultMonthlyPayment.doubleValue
var balance = self.balance.doubleValue + self.capitalizedInterest()
var rate = (self.interest.doubleValue / 12) / 100
var defaultScenario: Scenario! = getDefault(managedObjectContext)
self.thisLoansScenario = defaultScenario
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
var error: NSError?
self.mpForOneLoan = mpForThisLoan.copy() as! NSOrderedSet
defaultScenario.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet
defaultScenario.interestOverLife = totalInterest

//save
if !managedObjectContext.save(&error) {
println("Could not save: \(error)") }

//add in a few more features
let totalLoanInterest = self.getTotalInterestForLoansMP()
self.defaultTotalLoanInterest = totalLoanInterest
self.defaultTotalLoanMonths = self.mpForOneLoan.count
self.monthsInRepaymentTerm = self.mpForOneLoan.count
defaultScenario.defaultTotalScenarioInterest = totalInterest
if self.mpForOneLoan.count > defaultScenario.defaultTotalScenarioMonths.integerValue {
//set max
defaultScenario.defaultTotalScenarioMonths = self.mpForOneLoan.count
}
defaultScenario.defaultScenarioMaxPayment = defaultScenario.getScenarioMaxPayment()

//save
if !managedObjectContext.save(&error) {
println("Could not save: \(error)") }

}

func deleteLoanFromDefaultScenario(managedObjectContext:NSManagedObjectContext) {
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
self.thisLoansScenario = defaultScenario
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

//add in a few more features
let totalLoanInterest = self.getTotalInterestForLoansMP()
self.defaultTotalLoanInterest = totalLoanInterest
self.defaultTotalLoanMonths = self.mpForOneLoan.count
defaultScenario.defaultTotalScenarioInterest = totalInterest
if self.mpForOneLoan.count > defaultScenario.defaultTotalScenarioMonths.integerValue {
//set max
defaultScenario.defaultTotalScenarioMonths = self.mpForOneLoan.count
}
defaultScenario.defaultScenarioMaxPayment = defaultScenario.getScenarioMaxPayment()

//save
if !managedObjectContext.save(&error) {
println("Could not save: \(error)") }

}

let totalPaymentArray = self.makeArrayOfTotalPayments()
let maxPayment = maxElement(totalPaymentArray)
return maxPayment
}


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


//Set up Entry of information & delegates

/*    var balanceInterestTableView : BalanceInterestTableViewController?
var paymentContainerTableView : PaymentContainerTableViewController?
var graphView : GraphViewController?*/

/*  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
if segue.identifier == "BIContainer" {
self.balanceInterestTableView = segue.destinationViewController as? BalanceInterestTableViewController
//self.balanceInterestTableView?.parentViewController = self
}
else if segue.identifier == "paymentContainer" {
self.paymentContainerTableView = segue.destinationViewController as? PaymentContainerTableViewController
self.segmentIndex = self.paymentContainerTableView?.segmentedOutlet?.selectedSegmentIndex
println("here's a test")
}
else if segue.identifier == "graphContainerSegue"{
self.graphView = segue.destinationViewController as? GraphViewController
println("graphContainer Segue was run")
}
} */

//let balanceInterestVC = BalanceInterestTableViewController()

/*func didEnterLoan(balance:String,interest:String) {
println("Hello world")

if segmentIndex == 0 {
println("we are using the date picker")}
else if segmentIndex == 1 {
println("we are just using the monthly amount")}
else if segmentIndex == nil {
println("STILL NILL")
}*/


var totalGraphPoints = [Double]()
var interestGraphPoints = [Double]()

if enteredLoan != nil {

totalGraphPoints = enteredLoan!.makeArrayOfAllTotalPayments()
interestGraphPoints = enteredLoan!.makeArrayOfAllInterestPayments()
}
else {
totalGraphPoints = [0]
interestGraphPoints = [0]
}


/*
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

// Configure the cell...

return cell
}
*/

/*
// Override to support conditional editing of the table view.
override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
// Return NO if you do not want the specified item to be editable.
return true
}
*/

/*
// Override to support editing the table view.
override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
if editingStyle == .Delete {
// Delete the row from the data source
tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
} else if editingStyle == .Insert {
// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
}
}
*/

/*
// Override to support rearranging the table view.
override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

}
*/


// Override to support conditional rearranging of the table view.

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
}
*/

//picker material

/*UIColor.blueColor().setFill()
UIColor.blueColor().setStroke()

//set up the points line
var graphPath = UIBezierPath()
//go to start of line
graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
y:columnYPoint(principalGraphPoints[0])))

//add points for each item in the graphPoints array
//at the correct (x, y) for the point
for i in 1..<principalGraphPoints.count {
let nextPoint = CGPoint(x:columnXPoint(i),
y:columnYPoint(principalGraphPoints[i]))
graphPath.addLineToPoint(nextPoint)
}
//draw the line on top of the clipped gradient
graphPath.lineWidth = 2.0
graphPath.stroke()
//DrawtheInterest
//calculate the x point

var columnXPoint2 = { (column:Int) -> CGFloat in
//Calculate gap between points
let spacer = (width - margin*2 - 4) /
CGFloat((principalGraphPoints.count - 1))
var x:CGFloat = CGFloat(column) * spacer
x += margin + 2
return x
}

// calculate the y point

var columnYPoint2 = { (graphPoint:Double) -> CGFloat in
var y:CGFloat = CGFloat(graphPoint) /
CGFloat(maxValue) * graphHeight
y = graphHeight + topBorder - y // Flip the graph
return y
}

UIColor.redColor().setFill()
UIColor.redColor().setStroke()

var interestGraphPath = UIBezierPath()

//set up the points line

//go to start of line
interestGraphPath.moveToPoint(CGPoint(x:columnXPoint2(0),
y:columnYPoint2(interestGraphPoints[0])))

//add points for each item in the graphPoints array
//at the correct (x, y) for the point
for i in 1..<principalGraphPoints.count {
let nextPoint = CGPoint(x:columnXPoint2(i),
y:columnYPoint2(interestGraphPoints[i]))
interestGraphPath.addLineToPoint(nextPoint)
}
//draw the line on top of the clipped gradient
interestGraphPath.lineWidth = 2.0
interestGraphPath.stroke() */

///Draw line to mark one particular payment

//self.whiteLine.speed = 0.0
/*
CAWhiteLine.frame = CGRectMake(22,0,2,CGFloat(rect.height))
CAWhiteLine.backgroundColor = UIColor.whiteColor().CGColor

self.layer.addSublayer(CAWhiteLine)

let animation = CABasicAnimation(keyPath: "transform.translation.x")
animation.fromValue = 0 //NSValue(CGRect: CAWhiteLine.frame)
animation.toValue = rect.width - 6 //NSValue(CGRect: CGRectMake(140,0,4,CGFloat(rect.height)))
animation.duration = 1.0

CAWhiteLine.addAnimation(animation, forKey: "animate transform animation")

CAWhiteLine.speed = 0*/

//@IBInspectable var borderColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 1)
//@IBInspectable var startColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 0.7)
//@IBInspectable var endColor: UIColor = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 0.6)


let context = UIGraphicsGetCurrentContext()
CGContextSetLineWidth(context, 12.0)
CGContextSetStrokeColorWithColor(context, borderColor.CGColor)


//Gradient.  First, set up background clipping area
var path = UIBezierPath(rect: rect)
CGContextStrokeRect(context, rect)
path.addClip()
//2 - get the current context
let colors = [startColor.CGColor, endColor.CGColor]
//3 - set up the color space
let colorSpace = CGColorSpaceCreateDeviceRGB()
//4 - set up the color stops
let colorLocations:[CGFloat] = [0.0, 1.0]
//5 - create the gradient
let gradient = CGGradientCreateWithColors(colorSpace,
colors,
colorLocations)
//6 - draw the gradient
var startPoint = CGPoint.zeroPoint
var endPoint = CGPoint(x:0, y:self.bounds.height)
CGContextDrawLinearGradient(context,
gradient,
startPoint,
endPoint,
0)

/*   graphView.interest = getNSNumberFromString(BIView.interest.text)
graphView.balance = getNSNumberFromString(BIView.balance.text)
graphView.name = getLoanName()
graphView.type = getLoanType()
graphView.segmentedEntryType = paymentView.segmentedOutlet.selectedSegmentIndex
graphView.pickerMonth = paymentView.pickerData[0][paymentView.pickerOutlet.selectedRowInComponent(0)]
graphView.pickerYear = paymentView.pickerData[1][paymentView.pickerOutlet.selectedRowInComponent(1)]
graphView.numberOfMonthsPaid = NSNumber(double: paymentView.alreadyPaidStepper.value)
if firstLoan.monthsUntilRepayment.integerValue + firstLoan.monthsInRepaymentTerm.integerValue < 1 {
let alert = UIAlertView()
alert.title = "Alert"
alert.message = "Your loan should be paid off already based on the dates you entered"
alert.addButtonWithTitle("Understood")
alert.show()
}else{
//firstLoan.enteredLoanByPayment(managedObjectContext)
//firstLoan.enterLoanByDate(managedObjectContext)
firstLoan.monthsInRepaymentTerm = 0 // now obsolete because term will always be determined in Scenario
*/
//set default monthly payment, which accounts for whether payment has already started or not
self.defaultMonthlyPayment = NSNumber(double:self.getStandardMonthlyPayment(self.monthsUntilRepayment.integerValue))
var monthlyPayment = self.defaultMonthlyPayment.doubleValue
var balance = self.balance.doubleValue + self.capitalizedInterest()
var rate = (self.interest.doubleValue / 12) / 100
var totalMonths = self.monthsUntilRepayment.integerValue + self.monthsInRepaymentTerm.integerValue

//Pull up Monthly Payment Entity
let entity = NSEntityDescription.entityForName("MonthlyPayment", inManagedObjectContext: managedObjectContext)

//Get defaultScenario and set this loan's scenario
var defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
self.thisLoansScenario = defaultScenario

//build the set of monthly payments for this loan
let mpForThisLoan = self.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet

//add blank Monthly Payments for the total length.
while mpForThisLoan.count < totalMonths {
var monthlyPaymentToBeAdded = MonthlyPayment(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
monthlyPaymentToBeAdded.interest = 0//balance * rate
monthlyPaymentToBeAdded.principal = 0//monthlyPayment - (balance * rate)
monthlyPaymentToBeAdded.totalPayment = 0//monthlyPayment
mpForThisLoan.addObject(monthlyPaymentToBeAdded)
}

//make monthly payment array
var index = self.monthsUntilRepayment.integerValue
for mpPayment in mpForThisLoan {
if index > 0 { //we have months to wait until repayment begins
index = index - 1}
else { //index is less than or equal to zero, meaninag it is already in repayment or just starting
let mpPayment = mpPayment as! MonthlyPayment
if balance > monthlyPayment {
//and if it's not the last payment, add relevant values to the concatenated MP
mpPayment.addPayment(monthlyPayment,balance:balance, rate:rate)
balance = balance + (balance * rate) - monthlyPayment
}else if balance > 0 {//last payment
mpPayment.addFinalPayment(balance, rate:rate)
balance = 0
}
}

}
//save
var error: NSError?
self.mpForOneLoan = mpForThisLoan.copy() as! NSOrderedSet
if !managedObjectContext.save(&error) {
println("Could not save: \(error)") }

//add in a few more features
self.defaultTotalLoanInterest = self.getTotalInterestForLoansMP()
self.defaultTotalLoanMonths = self.mpForOneLoan.count
defaultScenario.defaultTotalScenarioMonths = maxElement([defaultScenario.defaultTotalScenarioMonths.integerValue,self.mpForOneLoan.count])

//save
if !managedObjectContext.save(&error) {
println("Could not save: \(error)") }

//
defaultScenario.addLoanToDefaultScenario(self, managedObjectContext: managedObjectContext)
let app = principallyApp()
app.printAllScenariosAndLoans()
defaultScenario.defaultScenarioMaxPayment = defaultScenario.getScenarioMaxPayment()

if !managedObjectContext.save(&error) {
println("Could not save: \(error)") }
//
//  EnteredViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 6/25/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class EnteredViewController: UIViewController {

/* //TODO: Add storyboard and view with all the pertinent loan information
//We aren't going to allow loans to be editable -- you can just delete and reenter.  if you're going to edit the repayment terms, that should be done through

@IBOutlet weak var loanName: UILabel!

@IBOutlet weak var loanType: UILabel!
@IBOutlet weak var loanBalance: UILabel!
@IBOutlet weak var loanInterest: UILabel!
@IBOutlet weak var graphOfEnteredLoan: GraphOfEnteredLoan!

@IBAction func graphSlider(sender: UISlider) {
sender.value = floor(sender.value)
let totalMonths = clickedLoan!.monthsInRepaymentTerm.floatValue - clickedLoan!.monthsUntilRepayment.floatValue
//graphOfEnteredLoan.CAWhiteLine.timeOffset = CFTimeInterval(sender.value / totalMonths)

let mpForThisLoan = clickedLoan!.mpForOneLoan.mutableCopy() as! NSMutableOrderedSet
var thisLoan = mpForThisLoan[Int(sender.value)] as! MonthlyPayment
var monthAndYear = clickedLoan!.getStringOfYearAndMonthForPaymentNumber(Double(sender.value))
paymentDescription.text = "This is payment number #\(sender.value) to be paid in \(monthAndYear), which consist of principal $\(thisLoan.principal) and $\(thisLoan.interest) in interest, for a total of $\(thisLoan.totalPayment)"
println(sender.value)
}

@IBOutlet weak var paymentDescription: UITextView!

@IBOutlet weak var graphSliderOutlet: UISlider!

var clickedLoan:Loan? = nil
override func viewDidLoad() {
super.viewDidLoad()
loanName.text = clickedLoan?.name
loanType.text = clickedLoan?.loanType
loanBalance.text = "$\(clickedLoan!.balance.stringValue)"
loanInterest.text = "\(clickedLoan!.interest.stringValue)%"
let tenthOfTheWay = (clickedLoan!.monthsInRepaymentTerm.floatValue - clickedLoan!.monthsUntilRepayment.floatValue)/10
graphOfEnteredLoan.enteredLoan = clickedLoan
graphSliderOutlet.maximumValue = clickedLoan!.defaultTotalLoanMonths.floatValue - 1
graphSliderOutlet.setValue(0, animated: true)
//graphOfEnteredLoan.CAWhiteLine.duration = NSTimeInterval(clickedLoan!.monthsInRepaymentTerm.floatValue - clickedLoan!.monthsUntilRepayment.floatValue)
}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
}



/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/
*/
}

//Recall that you created this when you thought you were using JBBarChart to accomplish the charting process.  Now you're using Core Graphics and Core Animation because of the limitations in redrawing and dynamically redrawing the chart.  This is here temporarily in case you recide to revert.  New UIViewController sublass is PayExtraCreateScenarioViewController.

//Recall that you might want to keep the Save Scenario button process.

/*
import UIKit
import CoreData
import JBChartView

class PayExtraViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate {

@IBOutlet weak var payExtraLineChart: JBLineChartView!


override func viewDidLoad() {
super.viewDidLoad()
payExtraLineChart.delegate = self
payExtraLineChart.dataSource = self
payExtraLineChart.backgroundColor = UIColor.darkGrayColor()
payExtraLineChart.minimumValue = 0 //mandatory and has to be a positive number
let max = maxElement(chartData)
payExtraLineChart.maximumValue = CGFloat(max)
payExtraLineChart.reloadData()
payExtraLineChart.setState(.Collapsed,animated:false)

}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
}

var oArray = [NSManagedObject]()
var sliderExtraNum : Int = 0
var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
var unsavedScenario: Scenario!
var newInterest : Double = 0
var chartData : [Double] = [0]
var originalChartData :[Double] = [0]

@IBOutlet weak var currentInterest: UILabel!

@IBOutlet weak var wouldPayNumber: UILabel!

@IBAction func saveScenarioButton(sender: UIButton) {
//save the unsaved scenario for further access

}

override func viewDidAppear(animated: Bool) {
//pull up the "unsaved" Scenario.
//By unsaved I mean it's not stored for future reference by the user and is currently editable. TODO:When the user leaves this page but doesn't save the scenario, this "unsaved" scenario is saved to be available later.  But once the user quits the program, this should be deleted so the user can start fresh.
let scenarioEntity = NSEntityDescription.entityForName("Scenario", inManagedObjectContext: managedObjectContext)
let unsavedScenarioName = "unsaved"
let scenarioFetch = NSFetchRequest(entityName: "Scenario")
scenarioFetch.predicate = NSPredicate(format: "name == %@", unsavedScenarioName)
var error: NSError?
let result = managedObjectContext.executeFetchRequest(scenarioFetch, error: &error) as! [Scenario]?

if let allScenarios = result {
if allScenarios.count == 0 {
unsavedScenario = Scenario(entity: scenarioEntity!, insertIntoManagedObjectContext: managedObjectContext)
unsavedScenario.name = unsavedScenarioName
}
else {unsavedScenario = allScenarios[0]}
}
else {
println("Coult not fetch \(error)")
}
//now pull up all the loans and save them as oArray
let loanFetchRequest = NSFetchRequest(entityName:"Loan")
let loanFetchedResults =
managedObjectContext.executeFetchRequest(loanFetchRequest,
error: &error) as? [NSManagedObject]

if let results = loanFetchedResults {
oArray = results
} else {
println("Coult not fetch \(error)")}
if oArray.count == 0 {
let alert = UIAlertView()
alert.title = "Alert"
alert.message = "You need to enter loans to explore repayment possibilities."
alert.addButtonWithTitle("Understood")
alert.show()
}
chartData = unsavedScenario.makeInterestArray()
originalChartData = chartData
//var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:Selector("showChart"),userInfo:nil, repeats:false)
payExtraLineChart.reloadData()
self.showChart()

}


@IBOutlet weak var sliderExtra: UILabel!

@IBAction func clickMeButton(sender: UIButton) {
println("Slider extra number is")
println("\(sliderExtraNum)")
newInterest = unsavedScenario.makeNewExtraPaymentScenario(managedObjectContext, oArray: oArray,extra:sliderExtraNum)
wouldPayNumber.text = "\(newInterest)"
//JBBarChart
chartData = unsavedScenario.makeInterestArray()
//Additional Set Up
// Do any additional setup after loading the view.
payExtraLineChart.reloadData()
payExtraLineChart.setState(.Collapsed, animated: false)
}


@IBOutlet weak var payExtraChartLegend: UILabel!

@IBAction func paymentSlider(sender: UISlider) {
sliderExtraNum = Int(sender.value/5) * 5//lroundf(sender.value)
sliderExtra.text = "\(sliderExtraNum)"
newInterest = unsavedScenario.makeNewExtraPaymentScenario(managedObjectContext, oArray: oArray,extra:sliderExtraNum)
wouldPayNumber.text = "\(newInterest)"
chartData = unsavedScenario.makeInterestArray()
payExtraLineChart.reloadData()
self.showChart()

//unsavedScenario.makeNewExtraPaymentScenario(oArray,extra:sliderExtraNum)
}


//TODO: Start here tomorrow.  See if you can get a graph of the interest paid over the life of the loan
//MARK: JBBarChartView data sourc methods to implement

func hideChart(){
self.payExtraLineChart.setState(.Collapsed, animated:true)
}

func showChart(){
self.payExtraLineChart.setState(.Expanded, animated:true)}

func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
return 1
}

func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
if (lineIndex == 0) {
if (Int(horizontalIndex) <= chartData.count){
return CGFloat(chartData[Int(horizontalIndex)])}
else{return 0}
}else{return 0}
}

func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
if (lineIndex == 0){
return UIColor.lightGrayColor()
}
else{return UIColor.lightGrayColor()}
}

func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
return true
}

func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
if (lineIndex == 0){
return UInt(originalChartData.count)
}else{return 0}
}

/* func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
return UInt(chartData.count)
}

func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
return CGFloat(chartData[Int(index)])
}

func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
return (index % 2 == 0) ? UIColor.lightGrayColor() : UIColor.whiteColor()
}

func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
let data = chartData[Int(index)]
let key = String(index)
payExtraChartLegend.text = "Payment #\(key) was \(data)"
}

func didDeselectBarChartView(barChartView: JBBarChartView!) {
payExtraChartLegend.text = ""
} */
}
*/
//
//  LoanEntryViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 5/17/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

/*protocol TypeViewDelegate{
func chooseTypeDidFinish(type:String)
} */

/*class LoanEntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, TypeViewDelegate {

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
firstLoan.monthsUntilRepayment = 0
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
GlobalLoanCount.sharedGlobalLoanCount.count = GlobalLoanCount.sharedGlobalLoanCount.count + 1

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


} */


*/