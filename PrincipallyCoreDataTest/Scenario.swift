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
    @NSManaged var newTotalScenarioInterest: NSNumber
    @NSManaged var newTotalScenarioMonths: NSNumber
    @NSManaged var defaultScenarioMaxPayment: NSNumber
    @NSManaged var newScenarioMaxPayment: NSNumber
    
    
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
    func makeNewExtraPaymentScenario (managedObjectContext:NSManagedObjectContext, oArray : NSMutableArray, extra:Int, monthsThatNeedExtraPayment:Int) -> Double{
        
        //In adding an extra paymenet we'd only ever expect the number of payment months to decrease -- so all we have to worry about is making sure that there are 0/0/0 MPs for all the extra days.  Intially we we pull up the max number of months
        let maxMonthsInDefaultRepayment :Int = self.getDefault(managedObjectContext).concatenatedPayment.count
        
        
        //reset interestoverlife and concat payment of the scenario we are working in.
        self.interestOverLife = 0
        if self.concatenatedPayment.count > 0 {
            for MP in self.concatenatedPayment {
                managedObjectContext.deleteObject(MP as! NSManagedObject)
            }
        }
        //have to save, otherwise you will still have the MPs in the concatenated payment when it's passed 
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        
        //setup default variable to count how far we are into adding the payments.
        var monthsWithExtraPayment : Int = 0
        
        //change oArray to lArray
        var lArray = [Loan]()
        for object in oArray {
            var object = object as! Loan
            lArray.append(object)
        }
        //now the highest rated loan is first and the lowest rated is last
        lArray.sort {$0.interest.doubleValue > $1.interest.doubleValue}
        
        //iterate over the loans in order. Determine the total number of months in that loan.  If the months in that loan is less than the months to which the extra payment has been applied already, enter that loan with the extra payment, returning the number of months that have now passed with the extra payment being applied.
        
        for loan in lArray {
            var loansTotalMonths = loan.monthsInRepaymentTerm.integerValue + loan.monthsUntilRepayment.integerValue
            if monthsWithExtraPayment < loansTotalMonths {
                let monthsToPayOffThisLoanWithExtraPayment = loan.enteredLoanWithExtraPayment(managedObjectContext,extra:Double(extra),currentScenario:self,monthsWithExtraPaymentAlready:monthsWithExtraPayment, monthsThatNeedExtraPayment:monthsThatNeedExtraPayment)
                monthsWithExtraPayment = monthsToPayOffThisLoanWithExtraPayment
                // Yes -- this is happening right. println("enteredLoanWithExtraPayment correctly")
            } else {
                loan.addLoanToCurrentScenario(managedObjectContext,currentScenario:self)
            }
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
        if !managedObjectContext.save(&error) {
            println("Could not save: \(error)") }
        return self.interestOverLife.doubleValue
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
        let totalPaymentArray = self.makeArrayOfTotalPayments()
        let maxPayment = maxElement(totalPaymentArray)
        return maxPayment
    }
    

    

}
