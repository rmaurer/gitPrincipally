//
//  MonthlyPayment.swift
//  
//
//  Created by Rebecca Maurer on 5/31/15.
//
//

import Foundation
import CoreData

class MonthlyPayment: NSManagedObject {

    @NSManaged var principal: NSNumber
    @NSManaged var interest: NSNumber
    @NSManaged var totalPayment: NSNumber
    @NSManaged var totalPrincipalSoFar: NSNumber
    @NSManaged var totalInterestSoFar: NSNumber
    @NSManaged var paymentIndex: NSNumber
    @NSManaged var loans: Loan
    @NSManaged var paymentConcatScenario: NSManagedObject

    func subtractAnotherMP(otherMP:MonthlyPayment){
        self.principal = self.principal.doubleValue - otherMP.principal.doubleValue
        self.interest = self.interest.doubleValue - otherMP.interest.doubleValue
        self.totalPayment = self.totalPayment.doubleValue - otherMP.totalPayment.doubleValue
    }

    func addAnotherMP(otherMP:MonthlyPayment){
        self.principal = self.principal.doubleValue + otherMP.principal.doubleValue
        self.interest = self.interest.doubleValue + otherMP.interest.doubleValue
        self.totalPayment = self.totalPayment.doubleValue + otherMP.totalPayment.doubleValue
    }
    
    func addPayment(mp:Double,balance:Double,rate:Double){
        self.principal = self.principal.doubleValue + mp - (balance * rate)
        self.interest = self.interest.doubleValue + (balance * rate)
        self.totalPayment = self.totalPayment.doubleValue + mp
    }
    
    func addFinalPayment(balance:Double,rate:Double){
        self.principal = self.principal.doubleValue + balance
        self.interest = self.interest.doubleValue + (balance * rate)
        self.totalPayment = self.totalPayment.doubleValue + balance + (balance * rate)
    }
    
    func addNonCoreDataPaymentToMP(nonCoreDataPayment:Payment_NotCoreData){
        self.principal = self.principal.doubleValue + nonCoreDataPayment.principal
        self.interest = self.interest.doubleValue + nonCoreDataPayment.interest
        self.totalPayment = self.totalPayment.doubleValue + nonCoreDataPayment.total
    }
}


class FakeScenario: NSManagedObject {
    
    @NSManaged var interestOverLife: NSNumber
    @NSManaged var scenarioDescription: String
    @NSManaged var name: String
    @NSManaged var allLoans: NSOrderedSet
    @NSManaged var concatenatedPayment: NSOrderedSet
    @NSManaged var defaultTotalScenarioInterest: NSNumber //delete
    @NSManaged var defaultTotalScenarioMonths: NSNumber //delete
    @NSManaged var nnewTotalScenarioInterest: NSNumber
    @NSManaged var nnewTotalScenarioMonths: NSNumber
    @NSManaged var nnewTotalCapitalizedInterest : NSNumber
    @NSManaged var nnewTotalPrincipal : NSNumber
    @NSManaged var repaymentType : String


}