//
//  NavController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 7/4/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    var color = UIColor(red: 26/255, green: 165/255, blue: 146/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = color
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name:"Menlo", size:20)]
        //, .color(UIColor.whiteColor())
        //NSFontAttributeName[UIFont .fontWithName(CaviarDreams.ttf, size: 20)]
        //    [NSDictionary dictionaryWithObjectsAndKeys:
         //   [UIFont fontWithName:@"mplus-1c-regular" size:21],
          //  NSFontAttributeName, nil]];
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
