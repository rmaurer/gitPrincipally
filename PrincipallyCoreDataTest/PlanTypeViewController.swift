//
//  PlanTypeViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class PlanTypeViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func standardButtonAction(sender: UIButton) {
        type = getAbbreviation(sender.currentTitle!)
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate!.chooseTypeDidFinish(type)
    
    }
    
    override func viewDidLayoutSubviews() {
        myScrollView.contentSize = CGSizeMake(myScrollView.frame.size.width, 1500);
        /*let scrollViewBounds = myScrollView.bounds
        let containerViewBounds = contentView.bounds
        
        var scrollViewInsets = UIEdgeInsetsZero
        scrollViewInsets.top = scrollViewBounds.size.height/2.0;
        scrollViewInsets.top -= contentView.bounds.size.height/2.0;
        
        scrollViewInsets.bottom = scrollViewBounds.size.height/2.0
        scrollViewInsets.bottom -= contentView.bounds.size.height/2.0;
        scrollViewInsets.bottom += 1
        
        myScrollView.contentInset = scrollViewInsets*/
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
        case "Income Based Repayment with PSLF":
            return "IBR with PSLF"
        case "Income Contingent Repayment with PSLF":
            return "ICR with PSLF"
        case "Pay As You Earn with PSLF":
            return "PAYE with PSLF"
        case "Limited: Income Based Repayment":
            return "IBR Limited"
        case "Limited: Pay As You Earn":
            return "PAYE Limited"
        case "Limited: Income Contingent Repayment":
            return "ICR Limited"
        default:
            return "Standard"
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
