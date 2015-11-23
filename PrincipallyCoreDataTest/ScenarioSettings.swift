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
    @NSManaged var thisSettingsScenario: Scenario
    
    func createDescription() -> String {
        var description : String = ""
        switch self.repaymentType{
            case "Standard":
                description = "Under a standard plan, your payments are based on the amount it will take to pay off all loans in full in 120 payments."
                if frequencyOfExtraPayments.doubleValue > 0 && frequencyOfExtraPayments.doubleValue < 999 {
                    description += " You are also making \(frequencyOfExtraPayments) extra payments of $\(amountOfExtraPayments) each"
            }
                else if frequencyOfExtraPayments.doubleValue == 999 {
                    description += " You are also making extra payments of $\(amountOfExtraPayments) each month until everything is paid off"
            }
            case "Extended":
                    description = "Under an extended plan, your payments are based on the amount it will take to pay off all loans in full in 300 payments."
                    if frequencyOfExtraPayments.doubleValue > 0 && frequencyOfExtraPayments.doubleValue < 999 {
                        description += " You are also making \(frequencyOfExtraPayments) extra payments of $\(amountOfExtraPayments) each"
                    }
                    else if frequencyOfExtraPayments.doubleValue == 999 {
                        description += " You are also making extra payments of $\(amountOfExtraPayments) each month until everything is paid off"
            }
            case "Refi":
                description = "You are refinancing your loan with a private company.  Under this program, we considered all of your loans eligible for refinance, and assumed that the refinance would take place immediately"
                if self.oneTimePayoff.doubleValue > 0 {
                   description += " The refinance company will make a one-time payoff of $\(oneTimePayoff)."
                }
                 description += "Your refinanced loans will be paid back over a \(refiTerm) year term."
                
                if variableInterestRate.boolValue && changeInInterestRate.doubleValue > 0 {
                    description += " Your new loan will start out with an interest rate of \(interestRateOnRefi)%.  This is a variable interest rate, and this program assumes that the interest rate will increase \(changeInInterestRate) percentage points over the repayment term"
                }
                else {
                    description += " And the fixed interest rate will be \(interestRateOnRefi)%"
                }
            
            case "IBR":
                description = "Under the Income-Based Repayment plan, your payments are based on your income, not the amount you owe."
                if ibrDateOptions.boolValue {
                    description += " Since you're a new borrower, you only pay up to 10% of your discretionary income, so long as you have financial hardship.  Any remaining balance after 20 years is cancelled."
                }
                else {
                        description += " You'll only pay up to 15% of your discretionary income, so long as you have financial hardship.  Any remaining balance after 25 years is cancelled."
                    }
                description += IBREligibleLoans()
                description += " These calculations are based on an adjusted gross income of $\(agi) and an annual salary increase of \(annualSalaryIncrease)%."
            
            case "ICR":
                description = "Under the Income-Contingent Repayment plan, your payments are limited to a maximum of 20% of your discretionary income.  However, the payments may be lower than that, depending on how much you owe.  You are eligible for cancellation in 20 years."
                description += ICREligibleLoans()
                description += " These calculations are based on an adjusted gross income of $\(agi) and an annual salary increase of \(annualSalaryIncrease)%."
            case "PAYE":
                    description = "Under the Pay As You Earn plan, your payments are based on your income, not the amount you owe.  You only pay up to 10% of your discretionary income, so long as you have financial hardship.  Any remaining balance after 20 years is cancelled."
                    description += PAYEEligibleLoans()
                    description += " These calculations are based on an adjusted gross income of $\(agi) and an annual salary increase of \(annualSalaryIncrease)%."
            case "IBR with PSLF":
                    description = "Under this plan, you make payments under IBR while in qualifying employment.  After 10 years, any remaining balance is cancelled. "
                    description += IBR_PSLFEligibleLoans()
                    description += " These calculations are based on an adjusted gross income of $\(agi) and an annual salary increase of \(annualSalaryIncrease)%."
            case "ICR with PSLF":
                    description = "Under the Income-Contingent Repayment plan, your payments are limited to a maximum of 20% of your discretionary income.  However, the payments may be lower than that, depending on how much you owe.  By combining ICR with PSLF, you are eligible for cancellation in 10 years."
                    description += ICR_PSLFEligibleLoans()
                    description += " These calculations are based on an adjusted gross income of $\(agi) and an annual salary increase of \(annualSalaryIncrease)%."
            case "PAYE with PSLF":
                    description = "Under the Pay As You Earn plan, your payments are based on your income, not the amount you owe.  You only pay up to 10% of your discretionary income, so long as you have financial hardship.  By combining PAYE with PSLF, you are eligible for cancellation in 10 years."
                    description += PAYE_PSLFEligibleLoans()
                    description += " These calculations are based on an adjusted gross income of $\(agi) and an annual salary increase of \(annualSalaryIncrease)%."
            case "IBR Limited":
                    description = "Under this plan, \(IBR_LimitedEligibleLoans()) will enter IBR repayment for \(yearsInProgram) years.  Then they will return to the standard 10-year plan for the remaining years."
            case "PAYE Limited":
                    description = "Under this plan, \(PAYE_ICR_LimitedEligibleLoans()) will enter PAYE repayment for \(yearsInProgram) years.  Then they will return to the standard 10-year plan for the remaining years."
            case "ICR Limited":
                    description = "Under this plan, \(PAYE_ICR_LimitedEligibleLoans()) will enter ICR repayment for \(yearsInProgram) years.  Then they will return to the standard 10-year plan for the remaining years."
        default:
            break
        }
        return description
    }


    func PAYE_ICR_LimitedEligibleLoans() -> String{
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var eligible = [Loan]()
        var ineligible = [Loan]()
        
        for object in oSet {
            var loan = object as! Loan
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "Direct, Subs."{
                eligible.append(loan)
            }
            else {
                ineligible.append(loan)
            }
        }
        
        var listofLoans : String = ""
        for index in 0...eligible.count-2 {
            listofLoans += " \(eligible[index].name),"
        }
        listofLoans += " and \(eligible[eligible.count-1].name)"
        
        return listofLoans
        
    }
    
    func IBR_LimitedEligibleLoans() -> String{
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var eligible = [Loan]()
        var ineligible = [Loan]()
        
        for object in oSet {
            var loan = object as! Loan
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "FFEL" || loan.loanType == "Direct, Subs."{
                eligible.append(loan)
            }
            else {
                ineligible.append(loan)
            }
        }
        
        var listofLoans : String = ""
        
        if eligible.count > 2 {
            for index in 0...eligible.count-2 {
                listofLoans += " \(eligible[index].name),"
            }
            listofLoans += " and \(eligible[eligible.count-1].name)"
        }
        
        else if eligible.count == 2 {
            listofLoans = "\(eligible[0].name) and \(eligible[1].name)"
        }
        
        else if eligible.count == 1{
            listofLoans = "\(eligible[0].name)"
        }
        
    
        return listofLoans
        
    }
    
    
    func PAYE_PSLFEligibleLoans() -> String{
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var eligible = [Loan]()
        var ineligible = [Loan]()
        
        for object in oSet {
            var loan = object as! Loan
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "Direct, Subs."{
                eligible.append(loan)
            }
            else {
                ineligible.append(loan)
            }
        }
        
        if ineligible.count == 0 {
            return " All your loans are eligible to enter PAYE repayment."
        }
        else if eligible.count == 1 {
            return " One of your loans, \(eligible[0].name), is eligible for PAYE repayment and cancellation in 10 years.  The rest of the loans are entered here on a 10-year repayment plan."
        }
        else if eligible.count > 1{
            var listofLoans : String = ""
            for index in 0...eligible.count-2 {
                listofLoans += " \(eligible[index].name),"
            }
            listofLoans += " and \(eligible[eligible.count-1].name)"
            return "\(listofLoans) are eligible to enter PAYE repayment. The remaining balance on these loans will be cancelled after 10 years. The rest of the loans are entered here on a 10-year repayment plan."
            
        }
        else {return ""}
        
    }
    
    
    
    func ICR_PSLFEligibleLoans() -> String{
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var eligible = [Loan]()
        var ineligible = [Loan]()
        
        for object in oSet {
            var loan = object as! Loan
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "Direct, Subs."{
                eligible.append(loan)
            }
            else {
                ineligible.append(loan)
            }
        }
        
        if ineligible.count == 0 {
            return " All your loans are eligible to enter ICR repayment."
        }
        else if eligible.count == 1 {
            return " One of your loans, \(eligible[0].name), is eligible for ICR repayment and cancellation in 10 years.  The rest of the loans are entered here on a 10-year repayment plan."
        }
        else if eligible.count > 1{
            var listofLoans : String = ""
            for index in 0...eligible.count-2 {
                listofLoans += " \(eligible[index].name),"
            }
            listofLoans += " and \(eligible[eligible.count-1].name)"
            return "\(listofLoans) are eligible to enter ICR repayment. The remaining balance on these loans will be cancelled after 10 years. The rest of the loans are entered here on a 10-year repayment plan."
            
        }
        else {return ""}
        
    }
    
    
    func IBR_PSLFEligibleLoans() -> String{
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var eligible = [Loan]()
        var ineligible = [Loan]()
        var FFEL = [Loan]()
        
        for object in oSet {
            var loan = object as! Loan
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "Direct, Subs."{
                eligible.append(loan)
            }
            else if loan.loanType == "FFEL" {
                FFEL.append(loan)
                ineligible.append(loan)
            }
            else {
                ineligible.append(loan)
            }
        }
        
        var string : String = ""
        
        if ineligible.count == 0 {
            string = " All your loans are eligible to enter IBR repayment and be forgiven in 10 years."
        }
        else if eligible.count == 1 {
            string = " One of your loans, \(eligible[0].name), is eligible for IBR repayment and cancellation in 10 years.  The rest of the loans are entered here on a 10-year repayment plan."
        }
        else if eligible.count > 1{
            var listofLoans : String = ""
            for index in 0...eligible.count-2 {
                listofLoans += " \(eligible[index].name),"
            }
            listofLoans += " and \(eligible[eligible.count-1].name)"
            string = " \(listofLoans) are eligible to enter IBR repayment. The remaining balance on these loans will be cancelled after 10 years.  The rest of the loans are entered here on standard 10-year repayment plan."
            
        }
        
        if FFEL.count > 0 {
            string += " You have some FFEL Program loans that are usually eligible for IBR repayment.  However, they are not eligible for PSLF loan forgiveness after 10 years.  Because of this, we have entered these loans on a standard 10-year repayment plan.  As with other types of ineligible loans, you can look into consolidating these loans to make them eligible for cancellation."
        }
        return string
    }
    
    

    
    
    func IBREligibleLoans() -> String{
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var eligible = [Loan]()
        var ineligible = [Loan]()

        for object in oSet {
            var loan = object as! Loan
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "FFEL" || loan.loanType == "Direct, Subs."{
                eligible.append(loan)
            }
            else {
                ineligible.append(loan)
            }
        }
        
        if ineligible.count == 0 {
            return " All your loans are eligible to enter IBR repayment."
        }
        else if eligible.count == 1 {
            return " One of your loans, \(eligible[0].name), is eligible to enter IBR repayment.  The rest of the loans are entered here on a 10-year repayment plan."
        }
        else if eligible.count > 1{
            var listofLoans : String = ""
            for index in 0...eligible.count-2 {
                listofLoans += " \(eligible[index].name),"
            }
            listofLoans += " and \(eligible[eligible.count-1].name)"
            return "\(listofLoans) are eligible to enter IBR repayment. The rest of the loans are entered here on a 10-year repayment plan."
        
        }
        else {return ""}

    }
    
    func ICREligibleLoans() -> String{
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var eligible = [Loan]()
        var ineligible = [Loan]()
        
        for object in oSet {
            var loan = object as! Loan
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "Direct, Subs."{
                eligible.append(loan)
            }
            else {
                ineligible.append(loan)
            }
        }
        
        if ineligible.count == 0 {
            return "All your loans are eligible to enter ICR repayment."
        }
        else if eligible.count == 1 {
            return "One of your loans, \(eligible[0].name), is eligible to enter ICR repayment.  The rest of the loans are entered here on a 10-year repayment plan."
        }
        else if eligible.count > 1{
            var listofLoans : String = ""
            for index in 0...eligible.count-2 {
                listofLoans += " \(eligible[index].name),"
            }
            listofLoans += " and \(eligible[eligible.count-1].name)"
            return "\(listofLoans) are eligible to enter ICR repayment. The rest of the loans are entered here on a 10-year repayment plan."
            
        }
        else {return ""}
        
    }
    
    func PAYEEligibleLoans() -> String{
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        let oSet = defaultScenario.allLoans
        var eligible = [Loan]()
        var ineligible = [Loan]()
        
        for object in oSet {
            var loan = object as! Loan
            if loan.loanType == "Direct, Unsubs."  || loan.loanType == "Grad PLUS" || loan.loanType == "Direct, Subs."{
                eligible.append(loan)
            }
            else {
                ineligible.append(loan)
            }
        }
        
        if ineligible.count == 0 {
            return " All your loans are eligible to enter PAYE repayment."
        }
        else if eligible.count == 1 {
            return " One of your loans, \(eligible[0].name), is eligible to enter PAYE repayment.  The rest of the loans are entered here on a 10-year repayment plan."
        }
        else if eligible.count > 1{
            var listofLoans : String = ""
            for index in 0...eligible.count-2 {
                listofLoans += " \(eligible[index].name),"
            }
            listofLoans += " and \(eligible[eligible.count-1].name)"
            return "\(listofLoans) are eligible to enter PAYE repayment. The rest of the loans are entered here on a 10-year repayment plan."
            
        }
        else {return ""}
        
    }
    
}
