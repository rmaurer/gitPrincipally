//
//  GraphedScenarioViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

//toDelete: superceded by graphViewController 
class GraphedScenarioViewController: UIViewController {
/*
    @IBOutlet weak var graphOfScenario: GraphOfScenario!
    
    @IBOutlet weak var nameLabelOutlet: UILabel!
    var name : String = ""
    var repaymentType : String = ""
    var frequencyOfExtraPayments : Int!
    var amountOfExtraPayments : Double!
    var interestRateOnRefi : Double!
    var variableInterestRate : Bool = false
    var changeInInterestRate : Double! // this one will need enum to describe options
    var AGI : Double!
    var annualSalaryIncrease : Double!
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
        currentScenario.repaymentType = repaymentType
        //currentScenario.description as String = "You are repaying your loans under the \(repaymentType) plan"
        
        
        switch currentScenario.repaymentType  {
        case "Default":
            //Todo: This should be deleted.  Will no longer have default entry
            //currentScenario.makeNewExtraPaymentScenario(managedObjectContext, extra:amountOfExtraPayments, MWEPTotal: frequencyOfExtraPayments)
            var test  = 0
        case "Standard Flat":
            
            if frequencyOfExtraPayments == 0 {
                currentScenario.standardFlat_WindUp(managedObjectContext)
            }
            else {
                currentScenario.standardFlatExtraPayment_WindUp(managedObjectContext, extra:amountOfExtraPayments, MWEPTotal: frequencyOfExtraPayments)
                
            }
            
        case "Standard Graduated":
            var test = 0
            //no longer doing this
        case "Extended":
            var test = 0
        case "Extended Graduated":
            var test = 0
        case "Default":
            var test = 0
        case "Refi":
            var test = 0
        case "IBR":
            var test = 0
        case "ICR":
            var test = 0
        case "PAYE":
            var test = 0
        case "IBR with PILF":
            var test = 0
        case "ICR with PILF":
            var test = 0
        case "PAYE with PILF":
            var test = 0
        default:
            var test = 0
        }

        
        
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
        graphOfScenario.graphedScenario = currentScenario
    }
    */

}
