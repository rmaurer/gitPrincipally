//
//  AppDelegate.swift
//  PrincipallyCoreDataTest
//
//  Created by Rebecca Maurer on 5/17/15.
//  Copyright (c) 2015 R.A. Maurer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //let tabBarController = self.window!.rootViewController as! UITabBarController
        //let loanNavigationController = tabBarController.viewControllers[1] as! UINavigationController
        
        //Because I have a tab bar view controller, I couldn't get it to work to set up the managedObjectContext upon launch in the AppDelegate.  This is the solution that I couldn't get how to implement in Swift //raywenderlich.com/forums/viewtopic.php?f=2&t=3297
        //Potentially post here if you need to get this working raywenderlich.com/forums/posting.php?mode=post&f=2
        //if let viewController = self.window!.rootViewController as? ViewController {
        //    viewController.managedContext = self.managedObjectContext!}
        return true
    }

    /*func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }*/

    func applicationDidEnterBackground(application: UIApplication) {
        CoreDataStack.sharedInstance.saveContext()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        CoreDataStack.sharedInstance.saveContext()
    }
    /*func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }*/

}

