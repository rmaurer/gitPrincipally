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

    //want it to add in interestOverLife, timeToRepay, and ConcadenatedPayment
    func makeNewExtraPaymentScenario (managedObjectContext:NSManagedObjectContext, extra:Int, MWEPTotal:Int){
        println("got into MakeNewExtraPayment")
        
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        
        let maxMonthsInDefaultRepayment :Int = self.defaultTotalScenarioMonths.integerValue
        
        
        //reset interestoverlife and concat payment of the scenario we are working in.
        self.interestOverLife = 0
        self.nnewScenarioMaxPayment = 0
        self.nnewTotalScenarioInterest = 0
        self.nnewTotalScenarioMonths = 0
     
        if self.concatenatedPayment.count > 0 {
            for MP in self.concatenatedPayment {
                managedObjectContext.deleteObject(MP as! NSManagedObject)
            }
        }
        
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

        //setup default variable to count how far we are into adding the payments.
        //
        var MWEPSoFar : Int = 0
        let entity = NSEntityDescription.entityForName("Loan", inManagedObjectContext: managedObjectContext)
        
        //change oArray to lArray
        var lArray = [Loan]()
        for object in oSet {
            var oldLoan = object as! Loan
            var newLoan = Loan(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            newLoan.thisLoansScenario = self
            oldLoan.copySelfToNewLoan(newLoan, managedObjectContext: managedObjectContext)
            lArray.append(newLoan)
        }
                        println("Got past making lArray")
        //now the highest interest-rate loan is first and the lowest rated is last
        lArray.sort {$0.interest.doubleValue > $1.interest.doubleValue}
        
        //iterate over the loans in order. Determine the total number of months in that loan.  If the months in that loan is less than the months to which the extra payment has been applied already, enter that loan with the extra payment, returning the number of months that have now passed with the extra payment being applied.
        
        var newScenarioMonths : Int = 0
        
        for loan in lArray {

            var loansTotalMonths = loan.defaultTotalLoanMonths.integerValue - 1
            //if we've already enough exta payments that we are past the months in the loan overall, we would never be adding extra payments to this loan, so we just add it straight away
            if MWEPSoFar >= loansTotalMonths {
                //doNothing
                loan.nnewTotalLoanInterest = loan.defaultTotalLoanInterest
                loan.nnewTotalLoanMonths = loan.defaultTotalLoanMonths
                newScenarioMonths = maxElement([newScenarioMonths, loan.defaultTotalLoanMonths.integerValue])
                if !managedObjectContext.save(&error) {
                    println("Could not save: \(error)") }
            }
            else if MWEPSoFar < MWEPTotal {
                let endMonthForExtraPayment = minElement([MWEPTotal, loansTotalMonths])
                MWEPSoFar = loan.enteredLoanWithExtraPayment(managedObjectContext,extraAmount:Double(extra),currentScenario:self,extraStart:MWEPSoFar, extraEnd:endMonthForExtraPayment)
                newScenarioMonths = maxElement([newScenarioMonths, loan.defaultTotalLoanMonths.integerValue])
                if !managedObjectContext.save(&error) {
                    println("Could not save: \(error)") }
            } else {
                loan.nnewTotalLoanInterest = loan.defaultTotalLoanInterest
                loan.nnewTotalLoanMonths = loan.defaultTotalLoanMonths
                newScenarioMonths = maxElement([newScenarioMonths, loan.defaultTotalLoanMonths.integerValue])
                if !managedObjectContext.save(&error) {
                    println("Could not save: \(error)") }
            }
        }
        
        self.nnewTotalScenarioMonths = newScenarioMonths
        self.windUpConcatenatedPaymentWithAllLoans(managedObjectContext)
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        println("got past saving")
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
        self.nnewTotalScenarioInterest = newInterest
        self.nnewScenarioMaxPayment = newMax
        self.concatenatedPayment = mpForAllLoans.copy() as! NSOrderedSet

        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
    }

    

}
