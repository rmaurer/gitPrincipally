//Recall that you created this when you thought you were using JBBarChart to accomplish the charting process.  Now you're using Core Graphics and Core Animation because of the limitations in redrawing and dynamically redrawing the chart.  This is here temporarily in case you recide to revert.  New UIViewController sublass is PayExtraCreateScenarioViewController. 

//Recall that you might want to keep the Save Scenario button process.

/*
import UIKit
import CoreData
import JBChartView

class PayExtraViewController: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate {
    
    @IBOutlet weak var payExtraLineChart: JBLineChartView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payExtraLineChart.delegate = self
        payExtraLineChart.dataSource = self
        payExtraLineChart.backgroundColor = UIColor.darkGrayColor()
        payExtraLineChart.minimumValue = 0 //mandatory and has to be a positive number
        let max = maxElement(chartData)
        payExtraLineChart.maximumValue = CGFloat(max)
        payExtraLineChart.reloadData()
        payExtraLineChart.setState(.Collapsed,animated:false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var oArray = [NSManagedObject]()
    var sliderExtraNum : Int = 0
    var managedObjectContext = CoreDataStack.sharedInstance.context as NSManagedObjectContext!
    var unsavedScenario: Scenario!
    var newInterest : Double = 0
    var chartData : [Double] = [0]
    var originalChartData :[Double] = [0]
    
    @IBOutlet weak var currentInterest: UILabel!
    
    @IBOutlet weak var wouldPayNumber: UILabel!
    
    @IBAction func saveScenarioButton(sender: UIButton) {
        //save the unsaved scenario for further access
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //pull up the "unsaved" Scenario.  
        //By unsaved I mean it's not stored for future reference by the user and is currently editable. TODO:When the user leaves this page but doesn't save the scenario, this "unsaved" scenario is saved to be available later.  But once the user quits the program, this should be deleted so the user can start fresh.
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
            else {unsavedScenario = allScenarios[0]}
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
        chartData = unsavedScenario.makeInterestArray()
        originalChartData = chartData
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:Selector("showChart"),userInfo:nil, repeats:false)
        payExtraLineChart.reloadData()
        self.showChart()
        
    }


    @IBOutlet weak var sliderExtra: UILabel!
    
    @IBAction func clickMeButton(sender: UIButton) {
        println("Slider extra number is")
        println("\(sliderExtraNum)")
        newInterest = unsavedScenario.makeNewExtraPaymentScenario(managedObjectContext, oArray: oArray,extra:sliderExtraNum)
        wouldPayNumber.text = "\(newInterest)"
        //JBBarChart
        chartData = unsavedScenario.makeInterestArray()
        //Additional Set Up
        // Do any additional setup after loading the view.
        payExtraLineChart.reloadData()
        payExtraLineChart.setState(.Collapsed, animated: false)
    }

    
    @IBOutlet weak var payExtraChartLegend: UILabel!
    
    @IBAction func paymentSlider(sender: UISlider) {
        sliderExtraNum = Int(sender.value/5) * 5//lroundf(sender.value)
        sliderExtra.text = "\(sliderExtraNum)"
        newInterest = unsavedScenario.makeNewExtraPaymentScenario(managedObjectContext, oArray: oArray,extra:sliderExtraNum)
        wouldPayNumber.text = "\(newInterest)"
        chartData = unsavedScenario.makeInterestArray()
        payExtraLineChart.reloadData()
                self.showChart()

        //unsavedScenario.makeNewExtraPaymentScenario(oArray,extra:sliderExtraNum)
    }
    
    
    //TODO: Start here tomorrow.  See if you can get a graph of the interest paid over the life of the loan 
    //MARK: JBBarChartView data sourc methods to implement
    
    func hideChart(){
        self.payExtraLineChart.setState(.Collapsed, animated:true)
    }
    
    func showChart(){
        self.payExtraLineChart.setState(.Expanded, animated:true)}
        
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        if (lineIndex == 0) {
            if (Int(horizontalIndex) <= chartData.count){
                return CGFloat(chartData[Int(horizontalIndex)])}
            else{return 0}
        }else{return 0}
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if (lineIndex == 0){
         return UIColor.lightGrayColor()
        }
        else{return UIColor.lightGrayColor()}
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if (lineIndex == 0){
            return UInt(originalChartData.count)
        }else{return 0}
    }
    
    /* func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return (index % 2 == 0) ? UIColor.lightGrayColor() : UIColor.whiteColor()
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let data = chartData[Int(index)]
        let key = String(index)
        payExtraChartLegend.text = "Payment #\(key) was \(data)"
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        payExtraChartLegend.text = ""
    } */
}
*/
