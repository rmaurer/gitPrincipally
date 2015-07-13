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





*/