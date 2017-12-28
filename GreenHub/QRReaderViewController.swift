//
//  QRReaderViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 29/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MultipeerConnectivity

//LETTORE QRCODE

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var detected: Bool = false
    public var gpToSend: Int = 0
    var peerID: MCPeerID!
    var mcSession: MCSession!
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mcSession.connectedPeers.count > 0 {
            do {
                let toSend = Data(bytes: &gpToSend, count: MemoryLayout.size(ofValue: gpToSend))
                try mcSession.send(toSend, toPeers: mcSession.connectedPeers, with: .reliable)
                print("Inviato")
                SettingsManager.manager.subGreenPoints(toSub: gpToSend)
                let ac = UIAlertController(title: "GP transfer success!", message: "Your GP was sent correctly!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in self.backTwo() }))
                present(ac, animated: true)
            } catch {
                print("Non inviato")
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in self.backTwo() }))
                present(ac, animated: true)
            }
        }
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
            //QUI
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) { //Per ricevere
        
    }

    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //Nothing detected
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                //DETECTED
                if !detected {
                    let qrString = metadataObj.stringValue
                    if qrString!.range(of: "GreenHub-") != nil {
                        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
                        mcBrowser.delegate = self
                        present(mcBrowser, animated: true)
                        print(metadataObj.stringValue)
                        detected = true
                    }
                }
            }
            else {
                detected = false
            }
        }
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
}

