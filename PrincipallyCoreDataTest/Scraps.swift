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

*/