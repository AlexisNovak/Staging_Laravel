//
//  DatabaseManager.swift
//  Zoomtivity
//
//  Created by Callum Trounce on 17/02/2017.
//  Copyright © 2017 Zoomtivity. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class DatabaseManager: NSObject {
    static let sharedDataManager = DatabaseManager()
    
    typealias POIResponseHandler = ([POI]) -> Void
    
    var context: NSManagedObjectContext!
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Zoomtivity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    override init() {
        super.init()
        context = persistentContainer.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch { }
    }
    
    func fetchPoints(type: String!,  southWestPoint: CLLocationCoordinate2D!, northEastPoint: CLLocationCoordinate2D!, completion: @escaping POIResponseHandler) {
        
        APIManager.sharedAPIManager.fetchPointsOfInterest(type: type,
                                                          southWestPoint: southWestPoint,
                                                          northEastPoint: northEastPoint,
                                                          completion: { points in
                                                            
                                                            var pointsOfInterest = [POI]()
                                                            
                                                            for point in points {
                                                                
                                                                let newFoodPOI = POIFood(context: self.context)
                                                                if let locationDetails = point["location"] {
                                                                    
                                                                    let locationDict = locationDetails as! [String : String]
                                                                    
                                                                    newFoodPOI.latitude = Double.init(locationDict["lat"]!)!
                                                                    newFoodPOI.longitude = Double.init(locationDict["lng"]!)!
                                                                    pointsOfInterest.append(newFoodPOI)
                                                                }
                                                            }
                                                            
                                                            completion(pointsOfInterest)
                                                                                  
        })
    }
    
        
}
