//
//  GPSendViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 29/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class GPSendViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerElements: [Int] = []
    private var gpToSend: Int = 0
    private var context = LAContext()
    private var authenticated: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPickerData()
        picker.delegate = self
        picker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPickerData()
        picker.delegate = self
        picker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SettingsManager.manager.getGreenPointsScore()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerElements[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        gpToSend = pickerElements[row]
    }
    
    private func fetchPickerData() {
        pickerElements = []
        for i in 1...SettingsManager.manager.getGreenPointsScore() {
            pickerElements.append(i)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQRScanView" {
            //let x = sender as! UIButton
            let controller = segue.destination as! QRReaderViewController
            if !authenticated {
                loginProcess()
            }
            controller.gpToSend = gpToSend
        }
    }
    
    private func loginProcess() {
        let policy = LAPolicy.deviceOwnerAuthentication
        let reason = "Authenticate"
        context.evaluatePolicy(policy, localizedReason: reason, reply: { (success, error) in
            DispatchQueue.main.async {
                
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessage()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        print("There was a problem verifying your identity.")
                    case LAError.userCancel:
                        print("Authentication was canceled by user.")
                        // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                    // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                    case LAError.userFallback:
                        print("The user tapped the fallback button (Fuu!)")
                    case LAError.systemCancel:
                        print("Authentication was canceled by system.")
                    case LAError.passcodeNotSet:
                        print("Passcode is not set on the device.")
                    case LAError.touchIDNotAvailable:
                        print("Touch ID is not available on the device.")
                    case LAError.touchIDNotEnrolled:
                        print("Touch ID has no enrolled fingers.")
                    // iOS 9+ functions
                    case LAError.touchIDLockout:
                        print("There were too many failed Touch ID attempts and Touch ID is now locked.")
                    case LAError.appCancel:
                        print("Authentication was canceled by application.")
                    case LAError.invalidContext:
                        print("LAContext passed to this call has been previously invalidated.")
                    // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                    default:
                        print("Touch ID may not be configured")
                        break
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                    return
                }
                // Good news! Everything went fine 👏
                print("OK")
                self.authenticated = true
            }
        })
        
    }
    private func showUnexpectedErrorMessage() {
        print("Unexpected error! 😱")
    }
}
