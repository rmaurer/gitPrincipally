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
