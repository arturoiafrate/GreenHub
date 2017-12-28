//
//  RecycleViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 31/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import WatchKit
import Foundation



class RecycleViewController: WKInterfaceController {
    
    @IBOutlet var recycleTable: WKInterfaceTable!
    
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
        WDBManager.manager.getAllRecycles()
        recycleTable.setNumberOfRows(WDBManager.manager.cities.count, withRowType: "RecycleRow")
        var i: Int = 0
        for city in WDBManager.manager.cities {
            let x = recycleTable.rowController(at: i) as! RecycleRow
            x.cityName.setText(city.value(forKey: "cityName") as? String)
            x.today.setText("today: \(city.value(forKey: WTimeStuff.manager.getTodayDate()) as! String)")
            i += 1
        }
    }
    @IBAction func dismissAllRecycles() {
        WDBManager.manager.dismissAllRecycles()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadTableData()
        }
        WConnectivityManager.manager.sendDismissRecycleAction()
        
    }
    
}
