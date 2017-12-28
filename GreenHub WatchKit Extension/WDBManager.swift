//
//  WDBManager.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 31/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import CoreData
import WatchKit

class WDBManager {
    public static var manager = WDBManager()
    public var cities: [NSManagedObject] = [] //Array di oggetti che contiene le città
    public var plants: [NSManagedObject] = []
    
    public func updateWRecycleRows(cities: [[String]]) {
        dropWRecycleTable()
        for city in cities {
            addRecycleRow(city: city)
        }
    }
    
    public func updateWPlantsRows(plants: [[String]]) {
        dropWPlantTable()
        for plant in plants {
            addPlantRow(plant: plant)
        }
    }
    
    
    private func getContext() -> NSManagedObjectContext {
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        return extensionDelegate.persistentContainer.viewContext
    }
    
    private func addRecycleRow(city: [String]) {
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "WRecycle", in: managedContext)!
        let row = NSManagedObject(entity: entity, insertInto: managedContext)
        row.setValue(city[0], forKey: "cityName")
        row.setValue(city[1], forKey: "sunday")
        row.setValue(city[2], forKey: "monday")
        row.setValue(city[3], forKey: "tuesday")
        row.setValue(city[4], forKey: "wednesday")
        row.setValue(city[5], forKey: "thursday")
        row.setValue(city[6], forKey: "friday")
        row.setValue(city[7], forKey: "saturday")
        do {
            try managedContext.save()
            print("salvataggio ok")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func addPlantRow(plant: [String]) {
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "WPlant", in: managedContext)!
        let row = NSManagedObject(entity: entity, insertInto: managedContext)
        row.setValue(plant[0], forKey: "plantName")
        row.setValue(plant[1], forKey: "plantKind")
        do {
            try managedContext.save()
            print("salvataggio ok")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func dismissAllRecycles() {
        dropWRecycleTable()
    }
    
    public func dismissAllPlants() {
        dropWPlantTable()
    }
    
    
    public func getAllRecycles() {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WRecycle")
        do { cities = try managedContext.fetch(fetchRequest) }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
    }
    
    
    public func getAllPlants() {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WPlant")
        do { plants = try managedContext.fetch(fetchRequest) }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
    }
    
    private func dropWRecycleTable() {
        let context = getContext()
        for city in cities {
            context.delete(city)
        }
        do {
            try context.save()
        } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
        cities = []
    }
    
    private func dropWPlantTable() {
        let context = getContext()
        for plant in plants {
            context.delete(plant)
        }
        do {
            try context.save()
        } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
        plants = []
    }
    
    
    private func removeRecycleRow(toDelete: NSManagedObject, index: Int) {
        let context = getContext()
        context.delete(toDelete)
        do {
            try context.save()
        } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
        cities.remove(at: index)
    }
    
    private func removePlantRow(toDelete: NSManagedObject, index: Int) {
        let context = getContext()
        context.delete(toDelete)
        do {
            try context.save()
        } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
        plants.remove(at: index)
    }
    
}
