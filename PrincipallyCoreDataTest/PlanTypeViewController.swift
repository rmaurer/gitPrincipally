//
//  PlanTypeViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class PlanTypeViewController: UIViewController {

    @IBAction func standardButtonAction(sender: UIButton) {
        type = getAbbreviation(sender.currentTitle!)
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate!.chooseTypeDidFinish(type)
    
    }

    
    @IBAction func test(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    var delegate:PlanViewDelegate? = nil
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAbbreviation (sender:String) -> String {
        switch sender{
        case "Default (loans as you entered them)":
            return "Default"
        case "Standard":
            return "Standard"
        case "Standard Graduated":
            return "Graduated"
        case "Extended":
            return "Extended"
        case "Extended Graduated":
            return "Extended Grad."
        case "Private Refinance":
            return "Refi"
        case "Income Based Repayment":
            return "IBR"
        case "Income Contingent Repayment":
            return "ICR"
        case "Pay As You Earn":
            return "PAYE"
        case "Income Based Repayment with Public Interest Loan Forgiveness":
            return "IBR with PILF"
        case "Income Contingent Repayment with Public Interest Loan Forgiveness":
            return "ICR with PILF"
        case "Pay As You Earn with Public Interest Loan Forgiveness":
            return "PAYE with PILF"
        case "Limited Number of Years: Income Based Repayment":
            return "IBR Limited"
        case "Limited Number of Years: Pay As You Earn":
            return "PAYE Limited"
        case "Limited Number of Years: Income Contingent Repayment":
            return "ICR Limited"
        default:
            return "Type"
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
