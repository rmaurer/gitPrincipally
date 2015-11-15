//
//  ScenarioSettings.swift
//  
//
//  Created by Rebecca Maurer on 11/15/15.
//
//

import Foundation
import CoreData

class ScenarioSettings: NSManagedObject {

    @NSManaged var repaymentType: String
    @NSManaged var frequencyOfExtraPayments: NSNumber
    @NSManaged var amountOfExtraPayments: NSNumber
    @NSManaged var interestRateOnRefi: NSNumber
    @NSManaged var variableInterestRate: NSNumber
    @NSManaged var changeInInterestRate: NSNumber
    @NSManaged var agi: NSNumber
    @NSManaged var annualSalaryIncrease: NSNumber
    @NSManaged var familySize: NSNumber
    @NSManaged var qualifyingJob: NSNumber
    @NSManaged var ibrDateOptions: NSNumber
    @NSManaged var icrReqs: NSNumber
    @NSManaged var payeReqs: NSNumber
    @NSManaged var refiTerm: NSNumber
    @NSManaged var yearsInProgram: NSNumber
    @NSManaged var oneTimePayoff: NSNumber
    @NSManaged var headOfHousehold: NSNumber

}
