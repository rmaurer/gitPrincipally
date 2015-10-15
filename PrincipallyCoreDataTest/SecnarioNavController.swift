//
//  SecnarioNavController.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 10/1/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit

class SecnarioNavController: UINavigationController {

    var color = UIColor(red: 26/255.0, green: 165/255.0, blue: 146/255.0, alpha: 1)
    var clippedcolor = UIColor(red: 0/255, green: 148/255, blue: 127/255, alpha: 1)
    var stupidcolor = UIColor(red: 61/255, green: 38/255, blue: 69/255, alpha: 1)
    var pinkColor = UIColor(red:242/255, green:95/255, blue:92/255, alpha:1)
    var greenPrincipallyColor = UIColor(red: 30/255, green: 149/255, blue: 127/255, alpha: 1)
    //73 53 72
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.whiteColor()//pinkColor
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : greenPrincipallyColor]
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = greenPrincipallyColor
        self.navigationBar.translucent = false 
        
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
