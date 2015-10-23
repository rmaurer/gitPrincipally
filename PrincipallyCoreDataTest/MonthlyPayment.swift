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
