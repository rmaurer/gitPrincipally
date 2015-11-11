//
//  CompareViewController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 5/23/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

class CompareViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageImages:[String]!
    var pageColors:[UIColor]!
    var pageViewController:UIPageViewController!
    var scenarioArray:[Scenario]!
    
    @IBAction func RestartButton(sender: AnyObject) {
        println("restartbutton worked") 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for scenario in scenarioArray {
            println("some scenarios got passed to the compareViewController")
            println(scenario.name)
        }
        
        pageImages = ["screen1","screen2","screen3"]
        pageColors = [UIColor.blueColor(), UIColor.purpleColor(), UIColor.lightGrayColor()]
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        var initialContentViewController = self.pageTutorialAtIndex(0) as ContentViewController
        
        var viewControllers = NSArray(object: initialContentViewController)
        
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-100)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func pageTutorialAtIndex(index: Int) -> ContentViewController
    {
        
        var pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        pageContentViewController.compareLabelText = pageImages[index]
        pageContentViewController.backgroundColor = pageColors[index]
        pageContentViewController.pageIndex = index
        pageContentViewController.scenarioArray = scenarioArray
        

        
        
        switch index {
        case 0:
            pageContentViewController.add1()
            pageContentViewController.compareLabelText = "I was successfully changed"
        case 1:
            pageContentViewController.add2()
            pageContentViewController.compareLabelText = "I was successfully changed"
        case 2:
            pageContentViewController.add4()
            pageContentViewController.compareLabelText = "Time 2"
        case 3:
            pageContentViewController.add3()
            pageContentViewController.compareLabelText = "Time 3" 
        default:
            break
        }
        
        
        return pageContentViewController
        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var viewController = viewController as! ContentViewController
        var index = viewController.pageIndex as Int
        
        if(index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index--
        
        return self.pageTutorialAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var viewController = viewController as! ContentViewController
        var index = viewController.pageIndex as Int
        
        if((index == NSNotFound))
        {
            return nil
        }
        
        index++
        
        if(index == pageImages.count)
        {
            return nil
        }
        
        return self.pageTutorialAtIndex(index)
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return pageImages.count
    }
    
    
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    


}
