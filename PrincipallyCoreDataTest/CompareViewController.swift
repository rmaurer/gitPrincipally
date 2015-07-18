//
//  CompareViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 5/23/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
//import JBChartView

class CompareViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
 /*
    @IBOutlet weak var barChart: JBBarChartView!
    
    @IBOutlet weak var informationLabel: UILabel!
    
    var chartLegend = ["11-14", "11-15","11-16", "11-17","11-18", "11-18", "11-20"]
    var chartData = [70, 80, 76, 90, 69, 70]
    
    //uncomment this to figure out JBBarChart
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGrayColor()

        // Do any additional setup after loading the view.
        barChart.backgroundColor = UIColor.darkGrayColor()
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0 //mandatory and has to be a positive number
        barChart.maximumValue = 100
        
        //TODO (according to little bar chart stuff), add footer and header
        barChart.reloadData()
        barChart.setState(.Collapsed, animated: false)
        
    
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //reload the data if anything's changed.  View is already loaded.  This is for when we come back and the chart appears again (like switching between different tabs)
        barChart.reloadData()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:Selector("showChart"),userInfo:nil, repeats:false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
    }
    
    func hideChart(){
        self.barChart.setState(.Collapsed, animated:true)
    }
    
    func showChart(){
        self.barChart.setState(.Expanded, animated:true)
    }

    //MARK: JBBarChartView data sourc methods to implement
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
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
        let key = chartLegend[Int(index)]
        informationLabel.text = "Weather on \(key) was \(data)"
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        informationLabel.text = ""
    } */

}
