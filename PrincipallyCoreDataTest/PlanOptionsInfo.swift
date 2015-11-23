//
//  GraphedScenarioViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

//toDelete: superceded by graphViewController 
class PlanOptionsInfo: UIViewController {

    @IBOutlet weak var infoTitleLabel: UILabel!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    var backgroundGrey = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
    
    var labelText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundGrey
        infoTitleLabel.text = labelText
        switch labelText {
        case "Variable Interest Rate":
            infoTextView.text = "Most federal loans have a fixed interest rate.  If your loan has an interest rate of 5.4% now, it will have a rate of 5.4% for the entire life of the loan.  However, when you refinance your loans, your interest rate might become a variable interest rate. The rate might be 2.0% or 3.5% now, but the interest rate may increase over time depending on changes in the global marketplace.  Nobody can know what interest rates will look like in the future.  But using this option, you can estimate what it would look like for your interest rate to increase over time."
        case "Extra Payments":
            infoTextView.text = "If you choose to pay back your loans under the Standard (10 year) or Extended (25 year) repayment plans, you may want to know what would happen if you could put extra money into your loans.  Here, you can specify how many extra payments you might make, and how much extra you could pay each time.  For instance, you can calculate what would happen if you could put an extra $100 into your loans each month for a year.  Or, you can calculate what would happen if you could make a one-time payment of $500 right now."
        case "Increases in Interest Rate":
            infoTextView.text = "Most variable interest rates are pegged to a global interest rate called the LIBOR.  So if the LIBOR goes up, so will the interest rate you pay on your privately refinanced loan.  This function allows you to see what it would look like if your interest goes up by some number of percentage points.  If you start with a 3% interest rate and then choose an increase of two percentage points, the program will assume a rise to 4% the first year, and then a rise to 5% the next year.  Then the program will calculate the rest of your payments assuming a 5% interest rate.  This program allows you to see what an increase of up to eight percentage points would look like.  Keep in mind that a variable interest rate could increase more than eight percentage points, it could change more quickly than the program assumes."
        case "Adjusted Gross Income":
            infoTextView.text = "The federal student loan website tell us that Adjusted Gross Income (AGI) is your \"total taxable income minus specific reductions.\"  You can get more specific guidance from the IRS website.  The simplest estimate is just to put in your total salary.  However, if you are married and file jointly, you need to include your spouse's income in your AGI.  For more information, go to https://studentaid.ed.gov/sa/repay-loans/understand/plans/income-driven "
        case "Annual Salary Increase":
            infoTextView.text = "As you become more experienced in your field, you can expect your salary to increase over time.  Because income-driven repayment plans are based on your salary, you'll want to consider what will happen as you get raises over time.  Here, you can estimate what your annual salary increase might look like.  For example, if you start with a base salary of $30,000 and have a 5% increase every year, at the end of 10 years, the estimator will assume you are earning $46,539."
        case "Family Size":
            infoTextView.text = "If you are single, your family size is 1.  Otherwise, the federal student loan website provides the following guidance: \"Family size includes you, your spouse, and your children (including unborn children who will be born during the year for which you certify your family size), if the children will receive more than half their support from you. It includes other people only if they live with you now, they receive more than half their support from you now, and they will continue to receive this support from you for the year that you certify your family size. Support includes: money, gifts, loans, housing, food, clothes, car, medical and dental care, and payment of college costs. For the purposes of these repayment plans, your family size may be different from the number of exemptions you claim on your federal income tax return.\" https://studentloans.gov/myDirectLoan/glossary.action"
        case "Qualifying Job":
            infoTextView.text = "In order to be eligible for Public Service Loan Forgiveness, you must be working at a qualifying job during the course of your 120 payments.  According to the federal student loan website jobs with these types of employers count \"Government organizations at any level (federal, state, local, or tribal); not-for-profit organizations that are tax-exempt under Section 501(c)(3) of the Internal Revenue Code; other types of not-for-profit organizations that provide certain types of qualifying public services.\" The website also notes that employment with labor unions and partisan political organizations do not qualify.  For more information, go to https://studentaid.ed.gov/sa/repay-loans/forgiveness-cancellation/public-service"
        case "New Borrower For IBR Program":
            infoTextView.text = "The percentage of your income you will pay in IBR differs depending on when you first borrowed federal student loans. You are a so-called \"new borrower\" if you took out your first federal loan after July 1, 2014, or if you repaid all your earlier loans before taking out a new loan after July 1, 2014.  If you are a new borrower, you pay no more than 10% of your discretionary income towards your loans in the IBR program.  If you borrowed loans earlier, you may still be eligible for the IBR program.  However, you will just pay 15% of your discretionary income towards your loans.  As with all income-drive repayment options, remember that your servicer will ultimately determine your eligibility.  For more information, go to https://studentaid.ed.gov/sa/repay-loans/understand/plans/income-driven"
        case "PAYE Date Requirements":
            infoTextView.text = "Only borrowers who took out loans after a certain date are eligible for the Pay As You Earn repayment plan.  To be eligible, you must meet two prongs.  First, you must have borrowed your first federal loan after October 1, 2007.  If you had federal loans from before October 1, 2007, you can still be eligible for PAYE only if those loans were completely repayed before taking out a new loan after October 1, 2007.  Second, you must have received a new loan, received a disbursement on an existing loan, or consolidated your loans after October 1, 2011. As with all income-drive repayment options, remember that your servicer will ultimately determine your eligibility.  For more information, go to https://studentaid.ed.gov/sa/repay-loans/understand/plans/income-driven"
        case "Years In Program":
            infoTextView.text = "You are choosing this repayment option, if you are expecting to be in an income-driven repayment plan for a set number of years, and then returning to the Standard (10-year) repayment plan.  Use this option to let the estimator know whether you are planning to be in income-driven repayment for 1 year, 2 years, 3 years or more.  Remember, the longer you stay in an income-driven plan, the higher your payments will be for the remainder of the 10 years."
        case "One Time Payoff":
            infoTextView.text = "Many private refinance companies offer a one-time payment as an incentive to refinance.  This option allows you to input that one-time payoff to see how it will affect your repayment plan."
        case "Loan Payment Information":
            infoTextView.text = "If your loan is already in repayment, put in the number of months in which you've already made payments.  For instance, if you started paying loans in December and it's currently the next June, put in 6.  If your loan is just about to enter repayment, you can keep this number at zero.  Or, if your loan will not enter repayment for some time, click Not Yet In Repayment and pick the correct month.  For information on the grace period you may have after graduation, go to https://studentaid.ed.gov/sa/repay-loans/understand#when-do-i-begin"
        default:
            infoTextView.text = ""
        }
        
        infoTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
 
}
