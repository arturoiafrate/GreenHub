//
//  ConnectivityManager.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 31/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import CoreData
import WatchConnectivity

class ConnectivityManager: NSObject {
    public static var manager = ConnectivityManager()
    public var session: WCSession!
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    public func sendBackgroundDataAsync() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //let toSend = ["recycles" : DBManager.manager.getRecyclesToSend()]
            let toSend = ["DB": DBManager.manager.getDBToSend()]
            do{
                try self.session.updateApplicationContext(toSend)
                print("Inviato")
            }
            catch { print("Niente da fare") }
        }
    }
}

extension ConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iOS: \(#function)") }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        WCSession.default().activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        let value = message["Messaggio"] as! String
        DispatchQueue.main.async {
            print("Ricevuto: \(value)")
        }
        replyHandler(["Messaggio":"ricezione lato iphone: ok"])
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        let value = applicationContext["dismiss"] as? [Bool]
        DispatchQueue.main.async {
            if value![0] {
                NotificationManager.manager.removeAllScheduledNotificationsForRecycle()
            }
            if value![1] {
                NotificationManager.manager.removeAllScheduledNotificationsForPlants()
            }
        }
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        print("Ricevuto \(userInfo)")
    }
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        DispatchQueue.main.async {
            
        }
    }
}
