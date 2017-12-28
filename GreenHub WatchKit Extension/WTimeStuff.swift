//
//  WTimeStuff.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 31/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

class WTimeStuff {
    public static var manager = WTimeStuff()
    private var today: Int = 0
    
    init() {
        today = (NSDateComponents().weekday % 7) + 1
    }
    
    public func getTodayDate() -> String {
        switch today {
        case 1:
            return "sunday"
        case 2:
            return "monday"
        case 3:
            return "tuesday"
        case 4:
            return "wednesday"
        case 5:
            return "thursday"
        case 6:
            return "friday"
        case 7:
            return "saturday"
        default:
            return "sunday"
        }
    }
}
