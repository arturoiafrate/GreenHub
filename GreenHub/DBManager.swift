//
//  DBManager.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class DBManager {
    public static var manager = DBManager()
    public var cities: [NSManagedObject] = [] //Array di oggetti che contiene le città
    public var plants: [NSManagedObject] = []
    
    
    // GET CONTEXT
    private func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    public func getImagePathForIndex(rowIndex: Int) -> String {
        var imagePath = cities[rowIndex].value(forKey: TimeStuff.time.getTodayDate()) as! String
        imagePath.append(".png")
        return imagePath
    }
    
    public func getRecyclesToSend() -> Any {
        var citiesToSend: [[String]] = []
        for i in 0..<cities.count {
            if cities[i].value(forKey: "isNotificationEnabled") as! Bool {
                var cityData: [String] = []
                cityData.append("\(cities[i].value(forKey: "cityName") as! String)")
                cityData.append("\(cities[i].value(forKey: "sunday") as! String)")
                cityData.append("\(cities[i].value(forKey: "monday") as! String)")
                cityData.append("\(cities[i].value(forKey: "tuesday") as! String)")
                cityData.append("\(cities[i].value(forKey: "wednesday") as! String)")
                cityData.append("\(cities[i].value(forKey: "thursday") as! String)")
                cityData.append("\(cities[i].value(forKey: "friday") as! String)")
                cityData.append("\(cities[i].value(forKey: "saturday") as! String)")
                citiesToSend.append(cityData)
            }
        }
        return citiesToSend as Any
    }
    
    public func getPlantsToSend() -> Any {
        var plantsToSend: [[String]] = []
        for i in 0..<plants.count {
            if plants[i].value(forKey: "isNotificationEnabled") as! Bool {
                var plantData: [String] = []
                plantData.append("\(plants[i].value(forKey: "plantName") as! String)")
                plantData.append("\(plants[i].value(forKey: "plantKind") as! String)")
                plantsToSend.append(plantData)
            }
        }
        return plantsToSend as Any
    }
    
    public func getDBToSend() -> Any {
        let recyclesAsAny = getRecyclesToSend()
        let plantsAsAny = getPlantsToSend()
//        let recycle = ["recycles" : recyclesAsAny] as Any
//        let plant = ["plants" : plantsAsAny] as Any
        return [recyclesAsAny, plantsAsAny] as Any
    }
    
    public func addRecycleRow(cityName: String, weekDay: [String], time: [Int]) { //Aggiunge una nuova riga alla tabella Recycle
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Recycle", in: managedContext)!
        let row = NSManagedObject(entity: entity, insertInto: managedContext)
        row.setValue(cityName, forKey: "cityName")
        row.setValue(weekDay[0], forKey: "sunday")
        row.setValue(weekDay[1], forKey: "monday")
        row.setValue(weekDay[2], forKey: "tuesday")
        row.setValue(weekDay[3], forKey: "wednesday")
        row.setValue(weekDay[4], forKey: "thursday")
        row.setValue(weekDay[5], forKey: "friday")
        row.setValue(weekDay[6], forKey: "saturday")
        row.setValue(time[0], forKey: "hours")
        row.setValue(time[1], forKey: "minutes")
        row.setValue(TimeStuff.time.getCurrentTimestamp(), forKey: "time")
        row.setValue(true, forKey: "isNotificationEnabled")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func addPlantRow(plant: [String], image: UIImage) {
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Plant", in: managedContext)!
        let row = NSManagedObject(entity: entity, insertInto: managedContext)
        row.setValue(plant[0], forKey: "plantName")
        row.setValue(plant[1], forKey: "plantKind")
        row.setValue(plant[2], forKey: "plantDesc")
        row.setValue(true, forKey: "isNotificationEnabled")
        let toSaveImg = UIImageJPEGRepresentation(image, 1)
        row.setValue(toSaveImg, forKey: "plantImg")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func removeRecycleRow(toDelete: NSManagedObject, index: Int) {
        let context = getContext()
        context.delete(toDelete)
        do {
            try context.save()
        } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
        cities.remove(at: index)

    }
    
    public func removePlantRow(toDelete: NSManagedObject, index: Int) {
        let context = getContext()
        context.delete(toDelete)
        do {
            try context.save()
        } catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
        plants.remove(at: index)
    }
    
    public func updateNotificationStatusForRow(rowID: Int, status: Bool) {
        let context = getContext()
        let toUpdate = cities[rowID]
        toUpdate.setValue(status, forKey: "isNotificationEnabled")
        do { try context.save() } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)") }
    }
    
    public func updateNotificationStatusForPlantRow(rowID: Int, status : Bool) {
        let context = getContext()
        let toUpdate = plants[rowID]
        toUpdate.setValue(status, forKey: "isNotificationEnabled")
        do { try context.save() } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)") }
    }
    
    public func getRowIdFromCityName(cityName: String) -> Int {
        for i in 0..<cities.count {
            if cities[i].value(forKey: "cityName") as! String == cityName {
                return i
            }
        }
        return -1
    }
    
    
    public func getAllRecycles() {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recycle")
        do { cities = try managedContext.fetch(fetchRequest) }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
    }
    
    public func getAllPlants() {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Plant")
        do { plants = try managedContext.fetch(fetchRequest) }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
    }
    
    public func dismissAllRecycleNotifications() {
        getAllRecycles()
        for i in 0..<cities.count {
            updateNotificationStatusForRow(rowID: i, status: false)
        }
    }
    
    public func dismissAllPlantNotifications() {
        getAllPlants()
        for i in 0..<plants.count {
            updateNotificationStatusForPlantRow(rowID: i, status: false)
        }
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
