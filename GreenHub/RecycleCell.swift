//
//  RecycleCell.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

//DataType delle celle dinamiche recycle

class RecycleCell: UITableViewCell {
    
    @IBOutlet weak var recycleImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var recycleKind: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    var rowID: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func switchPressed(_ sender: UISwitch) {
        if notificationSwitch.isOn {
         //Spegni notifiche
            DBManager.manager.updateNotificationStatusForRow(rowID: rowID, status: false)
            NotificationManager.manager.removeScheduledNotificationsForRecycle(cityName: cityName.text!)
            ConnectivityManager.manager.sendBackgroundDataAsync()
            notificationSwitch.isOn = false
        } else {
            //Accendi notifiche
            DBManager.manager.updateNotificationStatusForRow(rowID: rowID, status: true)
            notificationSwitch.isOn = true
            NotificationManager.manager.scheduleWeeklyRecycleNotification(city: DBManager.manager.cities[rowID])
            ConnectivityManager.manager.sendBackgroundDataAsync()
        }
    }

}
