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
        type = sender.currentTitle!//getAbbreviation(sender.currentTitle!)
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
        case "Standard":
            return "Standard"
        case "Standard Graduated":
            return "Gradated"
        case "Extended":
            return "extended"
        case "Extended Graduated":
            return "Extended Grad."
        case "Income Based Repayment":
            return "IBR"
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
