//
//  TypeModalVC.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 6/24/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class TypeModalVC: UIViewController {
    
    var delegate:TypeViewDelegate? = nil
    var type = ""

    @IBAction func Perkins(sender: UIButton) {
        type = getAbbreviation(sender.currentTitle!)
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate!.chooseTypeDidFinish(type)
    }
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
        case "Perkins":
            return "Perkins"
        case "Direct Stafford - Subsidized":
            return "Direct, Subs."
        case "Direct Stafford - Unsubsidized":
            return "Direct, Unsubs."
        case "Graduate PLUS Loans":
            return "Grad PLUS"
        case "Parent PLUS Loans":
            return "Parent PLUS"
        case "Direct Consolidated Loan":
            return "Consolidated"
        case "Direct Consolidated Loan that Includes ParentPLUS":
            return "Consolidated with ParentPLUS"
        case "FFEL Program":
            return "FFELP"
        case "Private Loan":
            return "Private"
        default:
            return "Loan"
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
