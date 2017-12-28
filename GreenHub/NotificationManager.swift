//
//  NotificationManager.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData
import UIKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    public static var manager = NotificationManager()
    
    
    public func requirePermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { granted, error in
        }
    }
    
    
    public func scheduleWeeklyRecycleNotification(cityName: String, weekDay: [String], time: [Int]){
        for i in 0...6 {
            let j = i + 1
            scheduleRecycleNotification(cityName: cityName, weekDay: j, recycle: weekDay[i], time: time)
        }
    }
    
    public func schedulePlantNotification(plant: [String]) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "PlantCategory"
        let action = UNNotificationAction(identifier: "GetPlantGP", title: "Got it! Give me GP +15", options: [])
        let action2 = UNNotificationAction(identifier: "GetGPandRemovePlantNotifications", title: "Get GP +15 and dismiss notifications", options: [])
        let localCat =  UNNotificationCategory(identifier: "PlantCategory", actions: [action, action2], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([localCat])
        content.title = "Remember to water \(plant[0])!"
        var lastWatering: Int = 0
        switch plant[1] {
        case "Aromatics":
            lastWatering = 2
        case "Bonsai":
            lastWatering = 4
        case "Water-retaining":
            lastWatering = 20
        default:
            lastWatering = 20
        }
        content.body = "You watered \(plant[0]) \(lastWatering) days ago. It's time to water it again!"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        let timeInterval = TimeInterval(86400*lastWatering)
        //let timeInterval = TimeInterval(30*lastWatering) //test
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        let identifier = "NID:\(plant[0])"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("Scheduled notification for \(plant[0]) at \(lastWatering) days with ID: \(identifier)")
    }
    
    public func scheduleWeeklyRecycleNotification(city: NSObject) {
        let cityName = city.value(forKey: "cityName") as! String
        let time = [city.value(forKey: "hours") as! Int, city.value(forKey: "minutes") as! Int]
        for i in 0...6 {
            let j = i + 1
            let day = TimeStuff.time.getWeekDayAsString(day: j)
            let recycle = city.value(forKey: day) as! String
            scheduleRecycleNotification(cityName: cityName, weekDay: j, recycle: recycle, time: time)
        }
    }
    
    public func removeScheduledNotificationsForRecycle(cityName: String) {
        for i in 1...7 {
            let notificationID = "NID:\(cityName)-day:\(i)"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationID])
            print("Deleted notification with identifier \(notificationID)")
        }
    }
    
    public func removeScheduledNotificationsForPlant(plantName: String) {
        let notificationID = "NID:\(plantName)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationID])
        print("Deleted notification with identifier \(notificationID)")
    }
    
    public func badgeToZero() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    public func removeAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        badgeToZero()
        DBManager.manager.getAllRecycles()
        DBManager.manager.getAllPlants()
        for i in 0..<DBManager.manager.cities.count {
            DBManager.manager.updateNotificationStatusForRow(rowID: i, status: false)
        }
        for i in 0..<DBManager.manager.plants.count {
            DBManager.manager.updateNotificationStatusForPlantRow(rowID: i, status: false)
        }
        print("Deleted all scheduled notifications.")
    }

    public func removeAllScheduledNotificationsForRecycle() {
        DBManager.manager.getAllRecycles()
        for i in 0..<DBManager.manager.cities.count {
            removeScheduledNotificationsForRecycle(cityName: DBManager.manager.cities[i].value(forKey: "cityName") as! String)
            DBManager.manager.updateNotificationStatusForRow(rowID: i, status: false)
        }
        print("Deleted all scheduled notifications for recycles.")
    }
    
    public func removeAllScheduledNotificationsForPlants() {
        DBManager.manager.getAllPlants()
        for i in 0..<DBManager.manager.plants.count {
            removeScheduledNotificationsForPlant(plantName: DBManager.manager.plants[i].value(forKey: "plantName") as! String)
            DBManager.manager.updateNotificationStatusForPlantRow(rowID: i, status: false)
        }
        print("Deleted all scheduled notifications for plants.")
    }
    
    private func scheduleRecycleNotification(cityName: String, weekDay: Int, recycle: String, time: [Int]) {
        if recycle != "None" {
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = "RecycleCategory"
            let action = UNNotificationAction(identifier: "GetGP", title: "Get GP", options: [])
            let action2 = UNNotificationAction(identifier: "GetGPandRemoveNotifications", title: "Get GP and dismiss notifications", options: [])
            let localCat =  UNNotificationCategory(identifier: "RecycleCategory", actions: [action, action2], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([localCat])
            content.title = "Today it's the \(recycle) day!"
            content.body = "Don't forget to throw your \(recycle) today in \(cityName)! And click here to get your Green Points!"
            content.sound = UNNotificationSound.default()
            content.badge = 1
            let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: time[0], minute: time[1], weekday: weekDay), repeats: true)
            let identifier = "NID:\(cityName)-day:\(weekDay)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("Scheduled notification for \(cityName) at \(time[0]):\(time[1]) of \(weekDay) with ID: \(identifier)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "GetGP":
            SettingsManager.manager.loadSavedSettings()
            SettingsManager.manager.addGreenPoints(toAdd: 1)
            badgeToZero()
        case "GetGPandRemoveNotifications":
            removeAllScheduledNotificationsForRecycle()
            SettingsManager.manager.loadSavedSettings()
            SettingsManager.manager.addGreenPoints(toAdd: 1)
            badgeToZero()
        case "GetPlantGP":
            SettingsManager.manager.loadSavedSettings()
            SettingsManager.manager.addGreenPoints(toAdd: 15)
            badgeToZero()
        case "GetGPandRemovePlantNotifications":
            removeAllScheduledNotificationsForPlants()
            SettingsManager.manager.loadSavedSettings()
            SettingsManager.manager.addGreenPoints(toAdd: 15)
            badgeToZero()
        default:
            print("???")
        }
    }
}
