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
            arrayOfAllPrincipalPayments.append(payment.interest.doubleValue)
        }
        return arrayOfAllPrincipalPayments
    }

    //want it to add in interestOverLife, timeToRepay, and ConcadenatedPayment
    func makeNewExtraPaymentScenario (managedObjectContext:NSManagedObjectContext, oArray : [NSManagedObject], extra:Int, monthNumber:Int) -> Double{
   
        var monthsWithExtraPayment : Int = 0
        var lArray = [Loan]()
        
        //change oArray to lArray
        for object in oArray {
            var object = object as! Loan
            lArray.append(object)
        }
        //now the highest rated loan is first and the lowest rated is last
        lArray.sort {$0.interest.doubleValue > $1.interest.doubleValue}
        
        //iterate over the loans in order. Determine the total number of months in that loan.  If the months in that loan is less than the months to which the extra payment has been applied already, enter that loan with the extra payment, returning the number of months that have now passed with the extra payment being applied. 
        self.interestOverLife = 0 //reset interestOverLife 
        
        for loan in lArray {
            var loansTotalMonths = loan.monthsUntilRepayment.integerValue + loan.monthsInRepaymentTerm.integerValue
            if monthsWithExtraPayment < loansTotalMonths {
                let monthsToPayOffThisLoanWithExtraPayment = loan.enteredLoanWithExtraPayment(managedObjectContext,extra:Double(extra),currentScenario:self,monthToStartAt:monthsWithExtraPayment)
                monthsWithExtraPayment = monthsToPayOffThisLoanWithExtraPayment
            } else {
                loan.addLoanToCurrentScenario(managedObjectContext,currentScenario:self)
            }
        }
        
        return self.interestOverLife.doubleValue
    }
    
    func makeInterestArray() -> [Double]{
        var interestArray = [Double]()
        let mpForAllLoans = self.concatenatedPayment.mutableCopy() as! NSMutableOrderedSet
        for payment in mpForAllLoans{
            var payment = payment as! MonthlyPayment
            interestArray.append(payment.interest.doubleValue)
        }
        return interestArray
    }
    

}
