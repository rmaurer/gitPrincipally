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
            infoTextView.text = "All federal loans are on a fixed interset rate.  This means that if your loan has an interst rate of 5.4% now, it will have a rate of 5.4% for the entire life of the loan.  However, when you refinance your loans into a private refinance option, your interest rate might become a variable interest rate. The rate might be 2.0% or 3.5% now, but the interest rate might increase over time depending on changes in the global marketplace.  If you do have a variable interest rate, you will have the chance to look at what your payments might look at if your interest rate changes over time"
        case "Variable Interest Rate":
            infoTextView.text = "If you choose to pay back your loans under the Standard (10 year) or Extended (25 year) repayment plans, you may want to know what would happen if you could put extra money into your loans.  Here, you can specify how many extra payments you might make, and how much extra you could pay each time.  For instance, you can calculate what would happen if you could put an extra $100 onto your loans each month for a year.  Or if you can make a one-time payment of $500 right now."
        case "Increases in Interest Rate":
            infoTextView.text = "Most variable interest rates are pegged to the LIBOR.  So if the LIBOR goes up, so will the interest rate you pay on your privately refinanced loan.  This function allows you to see what it would look like if your interest goes up 1%, 2%, 4%, 6% or 8%.  You can also see what happens if the interest rate stays the same.  Note that a variable interest rate could increase more than 8%, though it's less likely.  Based on the input you provide, the repayment estimator calculates a 1% increase per year.  Or if you don't have that many years left, the estimator assumes a 2% increase per year."
        case "Adjusted Gross Income":
            infoTextView.text = "The federal student loan website tell us that \"Adjusted Gross Income\" (AGI) is your \"total taxable income minus specific reductions.\"  You can get more specific guidance from the IRS website.  The simplest estimate is just to put in your total salary.  However, ubdiif you are married and file jointly, you need to include your spouse's income in your AGI"
        case "Annual Salary Increase":
            infoTextView.text = "As you become more experienced in your field, you can expect your salary to increase over time.  Because income-driven repayment plans are based on your salary, you'll want to consider what will happen as you get raises over time.  Here, you can estimate what your annual salary increase might look like.  For example, if you start with a base salary of $30,000 and have a 5% increase every year, at the end of 10 years, the estimator will assume you are earning $46,539"
        case "Family Size":
            infoTextView.text = "If you are single, your family size is 1.  Otherwise, the federal student loan website provides the following guidance: \"Family size includes you, your spouse, and your children (including unborn children who will be born during the year for which you certify your family size), if the children will receive more than half their support from you. It includes other people only if they live with you now, they receive more than half their support from you now, and they will continue to receive this support from you for the year that you certify your family size. Support includes: money, gifts, loans, housing, food, clothes, car, medical and dental care, and payment of college costs. For the purposes of these repayment plans, your family size may be different from the number of exemptions you claim on your federal income tax return.\" "
        case "Qualifying Job":
            infoTextView.text = "In order to be eligible for Public Interest Loan Forgiveness, you must be working at a qualifying job during the course of your 120 payments.  According to the federal student loan website jobs with these types of employers count \"Government organizations at any level (federal, state, local, or tribal); not-for-profit organizations that are tax-exempt under Section 501(c)(3) of the Internal Revenue Code; other types of not-for-profit organizations that provide certain types of qualifying public services.\" The webiste also notes that employment with labor unions and partisan political organizations do not qualify."
        case "New Borrower For IBR Program":
            infoTextView.text = "The percentage of your income you will pay in IBR differs depending on when you first borrowed federal student loans. You are a so-called “new borrowers” if you took out your  first federal loan after July 1, 2014, or if you repaid all your earlier loans before taking out a new loan after July 1, 2014.  If you are a new borrower, you pay no more than 10% of your discretionary income towards your loans in the IBR program.  However, if you borrowed loans earlier, you may still be eligible for the IBR program.  You will just pay 15% of your discretionary income towards your loans.  As with all income-drive repayment options, remember that your servicer will ultimately determine your eligibility."
        case "PAYE Date Requirements":
            infoTextView.text = "Only borrowers who took out loans after a certain date are eligible for the Pay As You Earn repayment plan.  To be eligible, you must meet two prongs.  First: you must have borrowed your first federal loan after October 1, 2007.  If you had federal loans from before October 1, 2007, you can still be eligible for PAYE only if those loans were completely repayed before taking out a new loan after October 1, 2007.  Second: you must have received a new loan, received a disbursement on an existing loan, or consolidated your loans after October 1, 2011. As with all income-drive repayment options, remember that your servicer will ultimately determine your eligibility."
        case "Years In Program":
            infoTextView.text = "Under this repayment option, you are expecting to be in an income-driven repayment plan for a set number of years and then return to the Standard (10-year) repayment plan.  Use this option to let the estimator know whether you are planning to be in income-driven repayment for 1 year, 2 years, 3 years or more.  Remember, the longer you stay in an income-driven plan, the higher your payments will be for the remainder of the 10 years to get everything paid off in time."
        case "One Time Payoff":
            infoTextView.text = "Many private refinance companies offer a one-time payment as an incentive to refinance.  This option allows you to input that one-time payoff to see how it will affect your repayment plan."
        default:
            infoTextView.text = ""
        }
        
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
