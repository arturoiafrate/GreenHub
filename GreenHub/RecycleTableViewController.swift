//
//  RecycleTableViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

//View controller della schermata principale recycle

class RecycleTableViewController: UITableViewController {
    
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
        return DBManager.manager.cities.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 95.0;//Choose your custom row height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = DBManager.manager.cities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecycleCell
        cell.rowID = indexPath.row
        cell.cityName.text = city.value(forKeyPath: "cityName") as? String
        cell.recycleImage.image = UIImage(named: DBManager.manager.getImagePathForIndex(rowIndex: indexPath.row))
        cell.recycleKind.text = "Today: \(city.value(forKey: TimeStuff.time.getTodayDate()) as! String)"
        cell.notificationSwitch!.isOn = city.value(forKey: "isNotificationEnabled") as! Bool
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Eliminazione
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            NotificationManager.manager.removeScheduledNotificationsForRecycle(cityName: DBManager.manager.cities[indexPath.row].value(forKey: "cityName") as! String)
            DBManager.manager.removeRecycleRow(toDelete: DBManager.manager.cities[indexPath.row], index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ConnectivityManager.manager.sendBackgroundDataAsync()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRowDetails" {
            let x = sender as! RecycleCell
            let controller = segue.destination as! RecycleDetailsViewController
            controller.rowID = x.rowID
        }
    }
    
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        });
    }
    
    @objc private func applicationStart() {
        DBManager.manager.getAllRecycles()
        SettingsManager.manager.loadSavedSettings()
        NotificationManager.manager.badgeToZero()
        refreshUI()
    }
}
