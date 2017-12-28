//
//  GrowingPlantsViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 01/08/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

class GrowingPlantsViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.manager.requirePermissions()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationStart),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        applicationStart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applicationStart()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.manager.plants.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 95.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = DBManager.manager.plants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as! PlantCell
        cell.rowID = indexPath.row
        cell.plantName.text = plant.value(forKey: "plantName") as? String
        cell.plantKind.text = plant.value(forKey: "plantKind") as? String
        cell.notificationSwitch!.isOn = plant.value(forKey: "isNotificationEnabled") as! Bool
        let img = plant.value(forKey: "plantImg") as! NSData
        cell.plantImage.image = UIImage(data: img as Data)!
       return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Eliminazione
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            NotificationManager.manager.removeScheduledNotificationsForPlant(plantName: DBManager.manager.plants[indexPath.row].value(forKey: "plantName") as! String)
            DBManager.manager.removePlantRow(toDelete: DBManager.manager.plants[indexPath.row], index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ConnectivityManager.manager.sendBackgroundDataAsync()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlantDetails" {
            let x = sender as! PlantCell
            let controller = segue.destination as! PlantDetailsViewController
            controller.rowID = x.rowID
        }
    }
    
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        });
    }
    
    @objc private func applicationStart() {
        DBManager.manager.getAllPlants()
        SettingsManager.manager.loadSavedSettings()
        NotificationManager.manager.badgeToZero()
        refreshUI()
    }
}
