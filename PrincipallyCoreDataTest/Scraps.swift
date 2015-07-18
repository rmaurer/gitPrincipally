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


*/