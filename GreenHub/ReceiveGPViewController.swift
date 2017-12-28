//
//  ReceiveGPViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 29/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit
import QRCode
import MultipeerConnectivity

//GENERATORE QRCode
//Fa partire una sessione

class ReceiveGPViewController: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var qrCode: UIImageView!
    
    let uuid = UIDevice.current.identifierForVendor!.uuidString
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receiveGPSelected),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        receiveGPSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        receiveGPSelected()
    }
    
    private func getQRImage() -> UIImage {
        let qrString = "GreenHub-\(uuid)"
        var qr = QRCode(qrString)!
        qr.size = self.qrCode.bounds.size
        //    qr.color = CIColor(rgba: "8e44ad")
        return qr.image!
    }
    
    @objc private func receiveGPSelected() {
        qrCode.image = getQRImage()
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        print("Session started")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            statusLabel.text = "Connected"
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            statusLabel.text = "Connecting..."
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            statusLabel.text = "Not connected"
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        var receved: Int = 0
        data.withUnsafeBytes{  (pointer: UnsafePointer<UInt8>) in
            receved = Int(pointer[0])
        }
        print("receved: \(receved)")
        SettingsManager.manager.addGreenPoints(toAdd: receved)
        let ac = UIAlertController(title: "GP receved successfully!", message: "You have receved \(receved) GP correctly!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in self.back() }))
        present(ac, animated: true)
    }
    
    private func back() {
        _ = navigationController?.popViewController(animated: true)
    }


}
