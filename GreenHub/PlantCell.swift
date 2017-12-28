//
//  PlantCell.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 01/08/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

class PlantCell: UITableViewCell {
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantKind: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    public var rowID: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func notificationSwitchPressed(_ sender: UISwitch) {
        if notificationSwitch.isOn {
            //Spegni notifiche
            DBManager.manager.updateNotificationStatusForPlantRow(rowID: rowID, status: false)
            NotificationManager.manager.removeScheduledNotificationsForPlant(plantName: plantName.text!)
            ConnectivityManager.manager.sendBackgroundDataAsync()
            notificationSwitch.isOn = false
        }
        else {
            //Accendi notifiche
            DBManager.manager.updateNotificationStatusForPlantRow(rowID: rowID, status: true)
            NotificationManager.manager.schedulePlantNotification(plant: [plantName.text!, plantKind.text!])
            ConnectivityManager.manager.sendBackgroundDataAsync()
            notificationSwitch.isOn = true
        }
    }
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
