//
//  PlantDetailsViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 01/08/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

class PlantDetailsViewController: UITableViewController  {
    var rowID: Int = 0

    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantKind: UILabel!
    @IBOutlet weak var plantDescription: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let plant = DBManager.manager.plants[rowID]
        title = "\(plant.value(forKey: "plantName") as! String) details:"
        plantName.text! = plant.value(forKey: "plantName") as! String
        plantKind.text! = plant.value(forKey: "plantKind") as! String
        plantDescription.text! = plant.value(forKey: "plantDesc") as! String
        let img = plant.value(forKey: "plantImg") as! NSData
        plantImage.image = UIImage(data: img as Data)!
    }
}
