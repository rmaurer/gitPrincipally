//
//  TestLoanEntryViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/26/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData


class TestLoanEntryViewController: UIViewController,UITextFieldDelegate, TypeViewDelegate {
    
    
    //Flipping view when loan is entered
    
    var loanIsEnteredGraphIsShowing : Bool = false

    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var entryContainer: UIView!
    
    @IBAction func doneButton(sender: UIBarButtonItem) {
        //now the person is editing the loan again, so switch the button to Done
        if loanIsEnteredGraphIsShowing {
            UIView.transitionFromView(graphContainer,
                toView: entryContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "Done"

        }
        else {
        //the person is entering the loan, so switch the button to editing
            UIView.transitionFromView(entryContainer,
                toView: graphContainer,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                | UIViewAnimationOptions.ShowHideTransitionViews, completion: nil)
            sender.title = "Edit"}
        
        loanIsEnteredGraphIsShowing = !loanIsEnteredGraphIsShowing
    }
    
    
    
    
    
    //Name
    @IBOutlet weak var editingPen: UIImageView!
    
    @IBOutlet weak var loanNameOutlet: UITextField!
    
    @IBAction func loanNameEditingChanged(sender: AnyObject) {
        editingPen.hidden = true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        let maxLength = 15
        let currentString: NSString = textField.text
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    //Select Loan Type
    let loanVC = TypeModalVC(nibName: "TypeModalVC", bundle: nil)
    
    @IBOutlet weak var selectLoanUIView: SelectLoanTypeView!
    
    @IBOutlet weak var selectLoantype: UIButton!
    
    @IBAction func selectLoanTypeAction(sender: UIButton) {
        loanVC.delegate = self
        loanVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(loanVC, animated: true, completion: nil)
        
    }
    
    func chooseTypeDidFinish(type:String){
        self.selectLoantype.setTitle(type, forState: .Normal)
        self.selectLoantype.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.selectLoanUIView.dashedBorder.lineDashPattern = [1,0]
        self.selectLoanUIView.dashedBorder.setNeedsDisplay()
    }

    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        loanNameOutlet.delegate = self
        editingPen.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
