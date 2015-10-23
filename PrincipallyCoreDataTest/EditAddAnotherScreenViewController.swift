//
//  EditAddAnotherScreenViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/20/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class EditAddAnotherScreenViewController: UIViewController {

     var delegate:EditButtonDelegate? = nil
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func addAnotherLoanButtonAction(sender: UIButton) {
    self.parentViewController!.navigationController!.popViewControllerAnimated(true)
    }
    @IBAction func editButtonAction(sender: UIButton) {
        delegate!.didPressSaveOrEditButton()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
