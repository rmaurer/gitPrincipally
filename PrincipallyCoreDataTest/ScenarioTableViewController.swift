//
//  ScenarioTableViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 9/30/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class ScenarioTableViewController: UITableViewController {
    
    var myScenarios = [NSManagedObject]()
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    var defaultScenario: Scenario!
    var compareScenarioArray = [Scenario]()
    
    var tableIsNotInSelectionMode : Bool = true
    
    @IBOutlet weak var compareButtonOutlet: UIBarButtonItem!
    
    @IBAction func compareButton(sender: UIBarButtonItem) {

        if tableIsNotInSelectionMode{
            self.tableView.setEditing(true, animated: true)
            self.tableView.reloadData()
             tableIsNotInSelectionMode = !tableIsNotInSelectionMode
        }
        
        else{
            if compareScenarioArray.count < 2 {
                self.tableView.setEditing(false, animated: true)
                self.tableView.reloadData()
                tableIsNotInSelectionMode = !tableIsNotInSelectionMode
                compareScenarioArray.removeAll(keepCapacity: false)
                compareButtonOutlet.title = "Compare"}
            else {
            self.performSegueWithIdentifier("compareSegue", sender: compareScenarioArray)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        defaultScenario = CoreDataStack.getDefault(CoreDataStack.sharedInstance)()
        myScenarios = CoreDataStack.getAllScenarios(CoreDataStack.sharedInstance)()
        self.tableView.reloadData()
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myScenarios.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableIsNotInSelectionMode {
            self.performSegueWithIdentifier("scenarioPressSegue", sender: indexPath)}
        else {
            compareScenarioArray.append(myScenarios[indexPath.row] as! Scenario)
            compareButtonOutlet.title = "Compare(\(compareScenarioArray.count))"
            println("multiple selections??")
        }
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        for index in 0...compareScenarioArray.count-1 {
            if compareScenarioArray[index].name == (myScenarios[indexPath.row] as! Scenario).name {
                compareScenarioArray.removeAtIndex(index)
            }
            
        }
        compareButtonOutlet.title = "Compare(\(compareScenarioArray.count))"
    }
    
   

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("scenarioCell", forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default,reuseIdentifier: "scenarioCell")}
        
        let newScenario = myScenarios[indexPath.row] as! Scenario
        
        cell!.textLabel!.text = newScenario.valueForKey("name") as? String

        return cell!
    }

    override func prepareForSegue
        (segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if segue.identifier == "scenarioPressSegue" {
                let indexPath = (sender as! NSIndexPath)
                let selectedScenario = myScenarios[indexPath.row] as! Scenario
                var vc:ReDoneRepaymentViewController = segue.destinationViewController as! ReDoneRepaymentViewController
                vc.selectedScenario = selectedScenario
            }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle
        editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            
            var error: NSError?
            
            if editingStyle == UITableViewCellEditingStyle.Delete {
                //1
                let scenarioToRemove = myScenarios[indexPath.row] as! Scenario
                scenarioToRemove.scenario_DeleteAssociatedObjectsFromManagedObjectContext(managedObjectContext)
                //2
                managedObjectContext.deleteObject(scenarioToRemove as NSManagedObject)
                //3
                if !managedObjectContext.save(&error) {
                    println("Could not save: \(error)") }
                //4
                //TODO:Fix this so that the loans properly re-allign.  This is throwing off the deleting process right now
                myScenarios = CoreDataStack.getAllScenarios(CoreDataStack.sharedInstance)()
                self.tableView.reloadData()
            }
    }
    
 
}
