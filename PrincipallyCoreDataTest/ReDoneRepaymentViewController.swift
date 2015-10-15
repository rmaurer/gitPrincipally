//
//  ReDoneRepaymentViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

protocol PlanViewDelegate{
    func chooseTypeDidFinish(type:String)
}

class ReDoneRepaymentViewController: UIViewController, PlanViewDelegate {
    var greenPrincipallyColor = UIColor(red: 30/255, green: 149/255, blue: 127/255, alpha: 1)
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    
       var scenarioWasEnteredGraphIsShowing : Bool = false
    
    @IBOutlet weak var parentFlipView: UIView!
    
    
    @IBOutlet weak var tableContainer: UIView!
    
    @IBOutlet weak var graphedScenarioContainer: UIView!
   
    
    @IBAction func doneButtonAction(sender: UIBarButtonItem) {
        //Here's where we do the flipping
        
        if scenarioWasEnteredGraphIsShowing {
            UIView.transitionFromView(graphedScenarioContainer,
                toView: tableContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "View Repayment"
            scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing
        }
        else{
            UIView.transitionFromView(tableContainer,
                toView: graphedScenarioContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "Edit"
            scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing
        }
        
    }

    
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    
     let typeXIBVC = PlanTypeViewController(nibName: "PlanTypeViewController", bundle: nil)
    
    @IBAction func selectPlanTypeButtonAction(sender: UIButton) {
        
        typeXIBVC.delegate = self
        typeXIBVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(typeXIBVC, animated: true, completion: nil)
    }
    
    func chooseTypeDidFinish(type:String){
        self.selectPlanTypeButtonOutlet.setTitle(type, forState: .Normal)
        self.selectPlanTypeButtonOutlet.setTitleColor(UIColor.grayColor(), forState: .Normal)
        //self.selectLoanUIView.dashedBorder.lineDashPattern = [1,0]
        //self.selectLoanUIView.dashedBorder.setNeedsDisplay()
    }
    
    
    @IBOutlet weak var selectPlanTypeButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteBackgroundView.layer.borderWidth = 4
        whiteBackgroundView.layer.borderColor = greenPrincipallyColor.CGColor
        //selectPlanTypeButtonOutlet.layer.backgroundColor = greenPrincipallyColor.CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

/*
    //Select Loan Type
    let loanVC = TypeModalVC(nibName: "TypeModalVC", bundle: nil)
    
    @IBOutlet weak var selectLoanUIView: SelectLoanTypeView!
    
    @IBOutlet weak var selectLoantype: UIButton!
    
    @IBAction func selectLoanTypeAction(sender: UIButton) {
    loanVC.delegate = self
    loanVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
    presentViewController(loanVC, animated: true, completion: nil)
    
    }
    

    
    
    */

}
