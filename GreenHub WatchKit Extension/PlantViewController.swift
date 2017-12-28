//
//  PlantViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 01/08/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import WatchKit

class PlantViewController: WKInterfaceController {
    @IBOutlet var plantTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        loadTableData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadTableData() {
        WDBManager.manager.getAllPlants()
        plantTable.setNumberOfRows(WDBManager.manager.plants.count, withRowType: "PlantRow")
        var i: Int = 0
        for plant in WDBManager.manager.plants {
            let x = plantTable.rowController(at: i) as! PlantRow
            x.plantName.setText(plant.value(forKey: "plantName") as? String)
            x.plantKind.setText("kind: \(plant.value(forKey: "plantKind") as! String)")
            i += 1
        }
    }
    
    @IBAction func dismissAllPlants() {
        
        WDBManager.manager.dismissAllPlants()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadTableData()
        }
        WConnectivityManager.manager.sendDismissPlantAction()
    }
}
