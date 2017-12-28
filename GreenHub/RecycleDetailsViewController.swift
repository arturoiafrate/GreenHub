//
//  RecycleDetailsViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

//ViewController della view per i dettagli recycle

class RecycleDetailsViewController: UITableViewController {
    var rowID: Int = 0
    @IBOutlet weak var sunday: UILabel!
    @IBOutlet weak var monday: UILabel!
    @IBOutlet weak var tuesday: UILabel!
    @IBOutlet weak var wednesday: UILabel!
    @IBOutlet weak var thursday: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var saturday: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let city  = DBManager.manager.cities[rowID]
        title = "\(city.value(forKeyPath: "cityName") as! String) details:"
        sunday.text! = city.value(forKey: "sunday") as! String
        monday.text! = city.value(forKey: "monday") as! String
        tuesday.text! = city.value(forKey: "tuesday") as! String
        wednesday.text! = city.value(forKey: "wednesday") as! String
        thursday.text! = city.value(forKey: "thursday") as! String
        friday.text! = city.value(forKey: "friday") as! String
        saturday.text! = city.value(forKey: "saturday") as! String
        let hours = city.value(forKey: "hours") as! Int
        let minutes = city.value(forKey: "minutes") as! Int
        var hoursL = "\(hours)"
        if hours < 10 { hoursL = "0\(hours)" }
        var minutesL = "\(minutes)"
        if minutes < 10 { minutesL = "0\(minutes)" }
        time.text! = "\(hoursL):\(minutesL)"
    }
    
    
}
