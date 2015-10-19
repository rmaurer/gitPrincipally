//
//  GraphedScenarioViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class GraphedScenarioViewController: UIViewController {

    @IBOutlet weak var nameLabelOutlet: UILabel!
    var name : String = ""
    var repaymentType : String = ""
    var frequencyOfExtraPayments : Int!
    var amountOfExtraPayments : Double!
    var interestRateOnRefi : Double!
    var variableInterestRate : Bool = false
    var changeInInterestRate : Double! // this one will need enum to describe options
    var AGI : Double!
    var familySize : Int!
    var qualifyingJob : Bool = false
    var IBRDateOptions : Bool = false
    var ICRReqs:Bool = false
    var PAYEReqs:Bool = false 
    
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    
    //globalScenarioVariable
    var currentScenario: Scenario!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scenario_WindUpForGraph() {
        let entity = NSEntityDescription.entityForName("Scenario", inManagedObjectContext: managedObjectContext)
        //set variable of what will be inserted into the entity "Loan"
        currentScenario = Scenario(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        currentScenario.name = name
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func scenario_UserWantsToEditAgain(){
        //we've got to delete the scenario from the list
        currentScenario.scenario_DeleteAssociatedObjectsFromManagedObjectContext(managedObjectContext)
        managedObjectContext.deleteObject(currentScenario as NSManagedObject)
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("could not save: \(error)")
        }

    }
    
    func scenario_makeGraphVisibleWithWoundUpScenario(){
        nameLabelOutlet.text = currentScenario.name
    }
    
    func scenario_MakeGraphVisibleWithoutAddingScenario() {
        //set up various outputs in the graphView using currentScenario
    }

}
