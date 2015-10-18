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
    
    @IBOutlet weak var planNameOutlet: UITextField!
    @IBAction func planNameAction(sender: UITextField) {
    }
    var greenPrincipallyColor = UIColor(red: 30/255, green: 149/255, blue: 127/255, alpha: 1)
    
    var scenarioWasEnteredGraphIsShowing : Bool = false
    
    let typeXIBVC = PlanTypeViewController(nibName: "PlanTypeViewController", bundle: nil)
    
    var planOptionsView = PlanOptionsTableViewController()
    var graphedScenarioView = GraphedScenarioViewController()
    
    var selectedScenario: Scenario?
    
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    @IBOutlet weak var parentFlipView: UIView!
    
    @IBOutlet weak var tableContainer: UIView!
    
    @IBOutlet weak var graphedScenarioContainer: UIView!
   
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var selectLoanUIView: SelectLoanTypeView!
    
    @IBOutlet weak var selectPlanTypeButtonOutlet: UIButton!
    
    @IBAction func doneButtonAction(sender: UIBarButtonItem) {
        //Here's where we do the flipping
        loadChildViews()
        if scenarioWasEnteredGraphIsShowing {
            graphedScenarioView.scenario_UserWantsToEditAgain()
            UIView.transitionFromView(graphedScenarioContainer,
                toView: tableContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "View Repayment"
            scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing

        }
        else{
            graphedScenarioView.name = planNameOutlet.text
            graphedScenarioView.scenario_WindUpForGraph()
            graphedScenarioView.scenario_makeGraphVisibleWithWoundUpScenario()
            UIView.transitionFromView(tableContainer,
                toView: graphedScenarioContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "Edit"
            scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing
        }
        
    }
    
    func flipAroundGraphWithoutLoadingScenario(){
        loadChildViews()
        graphedScenarioView.currentScenario = selectedScenario
        
        //graphedScenarioView.scenario_MakeGraphVisibleWithoutAddingScenario()
        graphedScenarioView.scenario_makeGraphVisibleWithWoundUpScenario()
        
        
        UIView.transitionFromView(tableContainer,
            toView: graphedScenarioContainer,
            duration: 1.0,
            options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
        doneButtonOutlet.title = "Edit"
        scenarioWasEnteredGraphIsShowing = !scenarioWasEnteredGraphIsShowing
    }
    
    @IBAction func selectPlanButtonAction(sender: UIButton) {
        typeXIBVC.delegate = self
        typeXIBVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(typeXIBVC, animated: true, completion: nil)
    
    }

    func chooseTypeDidFinish(type:String){
        self.selectPlanTypeButtonOutlet.setTitle(type, forState: .Normal)
        self.selectPlanTypeButtonOutlet.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.selectLoanUIView.dashedBorder.lineDashPattern = [1,0]
        self.selectLoanUIView.dashedBorder.setNeedsDisplay()
        let table = self.childViewControllers[1] as! PlanOptionsTableViewController
        table.selectedRepaymentPlan = type
        table.tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        whiteBackgroundView.layer.borderWidth = 4
        whiteBackgroundView.layer.borderColor = greenPrincipallyColor.CGColor
        if selectedScenario != nil {
            flipAroundGraphWithoutLoadingScenario()
        }
        //selectPlanTypeButtonOutlet.layer.backgroundColor = greenPrincipallyColor.CGColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadChildViews(){
        planOptionsView = self.childViewControllers[1] as! PlanOptionsTableViewController
        graphedScenarioView = self.childViewControllers[0] as! GraphedScenarioViewController
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
