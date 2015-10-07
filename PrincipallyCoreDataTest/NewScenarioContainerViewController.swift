//
//  NewScenarioContainerViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/4/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class NewScenarioContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        graphWidth.constant = self.view.frame.width - 32
        let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        newScenario.graphedScenario = defaultScenario
        var totalGraphPoints : [Double] = newScenario.graphedScenario!.makeArrayOfTotalPayments()
        //you need to set these for both Default & new!
        newScenario.maxHeight = Double(maxElement(totalGraphPoints))
        newScenario.maxWidth = totalGraphPoints.count
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var newScenario: GraphOfScenario!
    
    @IBOutlet weak var graphWidth: NSLayoutConstraint!
    
    var width = CGFloat()
    
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
    override func viewDidLoad() {
    super.viewDidLoad()
    graphWidth.constant = width
    let defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
    newScenario.graphedScenario = defaultScenario
    newScenario.setNeedsDisplay()
    // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var newScenario: GraphOfScenario!
    
    @IBOutlet weak var graphWidth: NSLayoutConstraint!
    
    var width = CGFloat()
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    */

}
