//
//  TimeStuff.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation

class TimeStuff {
    public static let time = TimeStuff()
    
    public func getCurrentTimestamp() -> Double {
        //Prendo l'orario attuale
        let date = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        let currentMinutes = calendar.component(.minute, from: date)
        //Lo trasformo in double
        let nowInSeconds = Double((currentMinutes * 60) + (currentHour * 3600))
        return nowInSeconds
    }
    
    public func getCurrentTime() -> [Int] {
        //Prendo l'orario attuale
        let date = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        let currentMinutes = calendar.component(.minute, from: date)
        return [currentHour, currentMinutes]
    }
    
    
    public func getTodayDate() -> String {
        let today = Date().dayNumberOfWeek()!
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
    
    public func getWeekDayAsString(day: Int) -> String {
        switch day {
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

    public func getWeekDay(day: String) -> Int {
        switch day {
        case "sunday":
            return 1
        case "monday":
            return 2
        case "tuesday":
            return 3
        case "wednesday":
            return 4
        case "thursday":
            return 5
        case "friday":
            return 6
        case "saturday":
            return 7
        default:
            return 1
        }
    }
}
