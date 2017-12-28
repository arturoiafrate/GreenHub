//
//  SettingsManager.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation

class SettingsManager {
    static var manager = SettingsManager()
    private var _settings: UserDefaults = UserDefaults.standard
    //private var _UUID: String = ""
    private var _gp: Int = 0
    
    init() {
        loadSavedSettings()
    }
    
    public func getGreenPointsScore() -> Int {
        return _gp
    }
    
    public func addGreenPoints(toAdd: Int) {
        _gp += toAdd
        _settings.set(_gp, forKey: "GreenPoints")
    }
    
    public func subGreenPoints(toSub: Int) {
        _gp -= toSub
        _settings.set(_gp, forKey: "GreenPoints")
    }
    
    public func loadSavedSettings() {//Carico e applico i settaggi
        let tmp = _settings.value(forKey: "GreenPoints") as? Int
        if tmp != nil {
            _gp = tmp!
        }
    }

}
