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

    @IBAction func loanTypeButton(sender: UIButton) {
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
        case "Direct Loan - Subsidized":
            return "Direct, Subs."
        case "Direct Loan - Unsubsidized":
            return "Direct, Unsubs."
        case "Graduate PLUS Loan":
            return "Grad PLUS"
        case "Parent PLUS Loan":
            return "Parent PLUS"
        case "FFEL Program Loan":
            return "FFEL"
        case "FFEL Parent Loan":
            return "FFELP Parent"
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
