//
//  GreenPointsViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

//ViewController della schermata che gestisce i GP

class GreenPointsViewController: UITableViewController {
    @IBOutlet weak var gpLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gpRefresh),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gpRefresh()
    }
    
    @objc private func gpRefresh() {
        SettingsManager.manager.loadSavedSettings()
        gpLabel.text = "\(SettingsManager.manager.getGreenPointsScore())"
        NotificationManager.manager.badgeToZero()
        if SettingsManager.manager.getGreenPointsScore() == 0 {
            sendButton.isEnabled = false
            sendButton.isOpaque = true
        }
        else {
            sendButton.isEnabled = true
            sendButton.isOpaque = false
        }
    }
}
