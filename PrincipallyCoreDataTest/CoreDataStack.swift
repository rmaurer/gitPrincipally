//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by Pietro Rea on 4/20/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import CoreData

class GlobalLoanCount{
    class var sharedGlobalLoanCount : GlobalLoanCount {
        struct Singleton {
            static let instance = GlobalLoanCount()
        }
        return Singleton.instance
    }
    var count : Int = 1
}


class CoreDataStack {
    
    class var sharedInstance : CoreDataStack {
        struct Singleton {
            static let instance = CoreDataStack()
        }
        return Singleton.instance
    }
    
  let context:NSManagedObjectContext
  let psc:NSPersistentStoreCoordinator
  let model:NSManagedObjectModel
  let store:NSPersistentStore?
  
  init() {
    //1
    let bundle = NSBundle.mainBundle()
    let modelURL =
    bundle.URLForResource("PrincipallyCoreDataTest", withExtension:"momd")
    model = NSManagedObjectModel(contentsOfURL: modelURL!)!
    
    //2
    psc = NSPersistentStoreCoordinator(managedObjectModel:model)
    
    //3
    context = NSManagedObjectContext()
    context.persistentStoreCoordinator = psc
    
    //4
    let documentsURL =
    CoreDataStack.applicationDocumentsDirectory()
    
    let storeURL =
    documentsURL.URLByAppendingPathComponent("PrincipallyCoreDataTest")
    
    let options =
    [NSMigratePersistentStoresAutomaticallyOption: true]
    
    var error: NSError? = nil
    store = psc.addPersistentStoreWithType(NSSQLiteStoreType,
      configuration: nil,
      URL: storeURL,
      options: options,
      error:&error)
    
    if store == nil {
      println("Error adding persistent store: \(error)")
      abort()
    }
  }
  
  func saveContext() {
    var error: NSError? = nil
    if context.hasChanges && !context.save(&error) {
    println("Could not save: \(error), \(error?.userInfo)")
    }
  }
    
    func getDefault() -> Scenario {
        let scenarioEntity = NSEntityDescription.entityForName("Scenario", inManagedObjectContext: self.context)
        let defaultScenarioName = "default"
        var defaultScenario: Scenario!
        let scenarioFetch = NSFetchRequest(entityName: "Scenario")
        scenarioFetch.predicate = NSPredicate(format: "name == %@", defaultScenarioName)
        var error: NSError?
        let result = self.context.executeFetchRequest(scenarioFetch, error: &error) as! [Scenario]?
        
        if let allScenarios = result {
            if allScenarios.count == 0 {
                defaultScenario = Scenario(entity: scenarioEntity!, insertIntoManagedObjectContext: self.context)
                defaultScenario.name = defaultScenarioName
            }
            else {defaultScenario = allScenarios[0]}
        }
        else {
            println("Coult not fetch \(error)")
        }
        return defaultScenario
    }
    
    func getUnsaved() -> Scenario {
        let scenarioEntity = NSEntityDescription.entityForName("Scenario", inManagedObjectContext: self.context)
        let unsavedScenarioName = "unsaved"
        var unsavedScenario: Scenario!
        let scenarioFetch = NSFetchRequest(entityName: "Scenario")
        scenarioFetch.predicate = NSPredicate(format: "name == %@", unsavedScenarioName)
        var error: NSError?
        let result = self.context.executeFetchRequest(scenarioFetch, error: &error) as! [Scenario]?
        
        if let allScenarios = result {
            if allScenarios.count == 0 {
                unsavedScenario = Scenario(entity: scenarioEntity!, insertIntoManagedObjectContext: self.context)
                unsavedScenario.name = unsavedScenarioName
            }
            else {unsavedScenario = allScenarios[0]}
        }
        else {
            println("Coult not fetch \(error)")
        }
        return unsavedScenario
    }
    

  class func applicationDocumentsDirectory() -> NSURL {
    let fileManager = NSFileManager.defaultManager()
    
    let urls = fileManager.URLsForDirectory(.DocumentDirectory,
      inDomains: .UserDomainMask) as! [NSURL]
    
    return urls[0]
  }
}
