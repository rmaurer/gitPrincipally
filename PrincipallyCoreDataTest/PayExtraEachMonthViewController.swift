//
//  PayExtraEachMonthViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/12/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PayExtraEachMonthViewController: UIViewController {

    var oArray = [NSManagedObject]()
    var sliderExtraNum : Int = 0
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    var unsavedScenario: Scenario!
    var defaultScenario: Scenario!
    var newInterest : Double = 0
    var newInterestLayer = CALayer()
    
    func convertSliderNumberToMonthsWithExtraPayment(senderValue:Int) -> Int {
        switch senderValue{
        case 1,2,3,4,5,6,7,8,9,10,11,12:
        return Int(senderValue)
        case 13:
        return 18
        case 14:
        return 24
        case 15:
        return 30
        case 16:
        return 36
        case 17:
        return 48
        case 18:
        return 60
        case 19:
        return 999
        default:
        return 999
        }
    }
    
    @IBAction func testButton(sender: UIButton) {
        //graphOfExtraPaymentScenario.CAWhiteLine.backgroundColor = UIColor.purpleColor().CGColor
        let maxInterest = maxElement(defaultScenario.makeArrayOfAllInterestPayments())
        newInterestLayer.sublayers = nil
        newInterestLayer = unsavedScenario.makeCALayerWithInterestLine(graphOfExtraPaymentScenario.frame, color: UIColor.purpleColor().CGColor, maxValue: maxInterest)
        graphOfExtraPaymentScenario.layer.addSublayer(newInterestLayer)
        graphOfExtraPaymentScenario.setNeedsDisplay()
        
        
    }
    
    @IBOutlet weak var graphOfExtraPaymentScenario: GraphOfScenario!
    
    @IBOutlet weak var extraAmount: UITextField!
    
    @IBAction func extraAmountEditingChanged(sender: UITextField) {
        if let extra = sender.text.toInt() {
            //it's a number, and we need to do our extra payment calculaions using the "number of extra payments slider.
            //What should this program do? 
                //1) It should wind up our unsavedScenario (USS) with the MP array for all loans
                //2) It should delete the previous USS line in the graph, and replace it with the new line
                //3) It should change the amount of interest saved
                //4) It should perhaps produce some type of string that describes the scenario? This might be a task for later, though
            //It's going to have to do this based on two particular variables: the extra amount paid, AND the nubmer of months during which payment is made.
            let monthNumber = convertSliderNumberToMonthsWithExtraPayment(Int(frequencySliderOutlet.value))
            newInterest = unsavedScenario.makeNewExtraPaymentScenario(managedObjectContext, oArray: oArray,extra:extra,monthsThatNeedExtraPayment:monthNumber)
            //println(unsavedScenario.concatenatedPayment)
            
        }else{
            println("it's a string")
            graphOfExtraPaymentScenario.CAWhiteLine.timeOffset = 0.5
            //it's a string, and we don't do any calculations
        }
    }
    @IBOutlet weak var frequencySliderOutlet: UISlider!
    
    @IBAction func frequencySlider(sender: UISlider) {
        sender.value = Float(Int(sender.value))
        switch sender.value {
        case 1:
            return frequencyLabel.text = "1 month"
        case 2,3,4,5,6,7,8,9,10,11:
            return frequencyLabel.text = "\(Int(sender.value)) months"
        case 12:
            return frequencyLabel.text = "12 months"
        case 13:
            return frequencyLabel.text = "18 months"
        case 14:
            return frequencyLabel.text = "24 months"
        case 15:
            return frequencyLabel.text = "30 months"
        case 16:
            return frequencyLabel.text = "3 years"
        case 17:
            return frequencyLabel.text = "4 years"
        case 18:
            return frequencyLabel.text = "5 years"
        case 19:
            return frequencyLabel.text = "Every time"
        default:
            return frequencyLabel.text = "Every time"
        }
        
    }
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scenarioEntity = NSEntityDescription.entityForName("Scenario", inManagedObjectContext: managedObjectContext)
        let unsavedScenarioName = "unsaved"
        let scenarioFetch = NSFetchRequest(entityName: "Scenario")
        scenarioFetch.predicate = NSPredicate(format: "name == %@", unsavedScenarioName)
        var error: NSError?
        let result = managedObjectContext.executeFetchRequest(scenarioFetch, error: &error) as! [Scenario]?
        
        if let allScenarios = result {
            if allScenarios.count == 0 {
                unsavedScenario = Scenario(entity: scenarioEntity!, insertIntoManagedObjectContext: managedObjectContext)
                unsavedScenario.name = unsavedScenarioName
            }
            else {
                unsavedScenario = allScenarios[0]
            }
        }
        else {
            println("Coult not fetch \(error)")
        }
        //now pull up all the loans and save them as oArray
        let loanFetchRequest = NSFetchRequest(entityName:"Loan")
        let loanFetchedResults =
        managedObjectContext.executeFetchRequest(loanFetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = loanFetchedResults {
            oArray = results
        } else {
            println("Coult not fetch \(error)")}
        if oArray.count == 0 {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "You need to enter loans to explore repayment possibilities."
            alert.addButtonWithTitle("Understood")
            alert.show()
        }
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        defaultScenario = unsavedScenario.getDefault(managedObjectContext)
        let maxInterest = maxElement(defaultScenario.makeArrayOfAllInterestPayments())
        let newLayer = defaultScenario.makeCALayerWithInterestLine(graphOfExtraPaymentScenario.frame, color: UIColor.blackColor().CGColor, maxValue: maxInterest)
        graphOfExtraPaymentScenario.layer.addSublayer(newLayer)
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
