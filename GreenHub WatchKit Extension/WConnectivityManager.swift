//
//  WConnectivityManager.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 31/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import CoreData
import WatchConnectivity
import WatchKit

class WConnectivityManager: NSObject {
    public static var manager = WConnectivityManager()
    public var session: WCSession!

    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    public func sendDismissRecycleAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let toSend = ["dismiss" : self.dismissObjectToSend(recycle: true, plant: false)]
//            let toSend = ["recycles" : "dismissAll"]
            do{
                try self.session.updateApplicationContext(toSend)
                print("Inviato")
                }
                catch { print("Niente da fare") }
        }
    }
    
    public func sendDismissPlantAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let toSend = ["dismiss" : self.dismissObjectToSend(recycle: false, plant: true)]
            //            let toSend = ["recycles" : "dismissAll"]
            do{
                try self.session.updateApplicationContext(toSend)
                print("Inviato")
            }
            catch { print("Niente da fare") }
        }
    }
    
    private func dismissObjectToSend(recycle: Bool, plant: Bool) -> Any {
        return [recycle, plant] as Any
    }
    
}

extension WConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("watchOS: \(#function)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //let value = message["Messaggio"] as? [NSManagedObject]
        DispatchQueue.main.async {
            print("Ricevuto")
            
        }
        replyHandler(["Messaggio":"ricezione lato Watch: ok"])
    }
    //QUESTA QUI
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        //let values = applicationContext["recycles"] as? [[String]]
        let values = applicationContext["DB"] as? [[[String]]]
        DispatchQueue.main.async {
            WDBManager.manager.updateWRecycleRows(cities: values![0])
            WDBManager.manager.updateWPlantsRows(plants: values![1])
           // WDBManager.manager.updateWRecycleRows(cities: values!)
            
//            for i in 0..<values!.count {
//                let cityInfo = values![i]
//                print(cityInfo[0])
//            }
        }
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        if (error != nil) {
            print("error")
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        DispatchQueue.main.async {
            
        }
    }
}
