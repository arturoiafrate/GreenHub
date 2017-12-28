//
//  AddRecycleViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 28/07/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity
import CoreData

//ViewController della view per aggiungere una nuova città

class AddRecycleViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var sundayPicker: UIPickerView!
    @IBOutlet weak var mondayPicker: UIPickerView!
    @IBOutlet weak var tuesdayPicker: UIPickerView!
    @IBOutlet weak var wednesdayPicker: UIPickerView!
    @IBOutlet weak var thursdayPicker: UIPickerView!
    @IBOutlet weak var fridayPicker: UIPickerView!
    @IBOutlet weak var saturdayPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    private let pickerElements: [String] = ["None","Paper", "Plastic", "Organic", "Glass", "Other"]
    private var _mondaySelected: String = "None"
    private var _tuesdaySelected: String = "None"
    private var _wednesdaySelected: String = "None"
    private var _thursdaySelected: String = "None"
    private var _fridaySelected: String = "None"
    private var _saturdaySelected: String = "None"
    private var _sundaySelected: String = "None"
    private var hours: Int = 0
    private var minutes: Int = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mondayPicker.delegate = self
        mondayPicker.dataSource = self
        tuesdayPicker.delegate = self
        tuesdayPicker.dataSource = self
        wednesdayPicker.delegate = self
        wednesdayPicker.dataSource = self
        thursdayPicker.delegate = self
        thursdayPicker.dataSource = self
        fridayPicker.delegate = self
        fridayPicker.dataSource = self
        saturdayPicker.delegate = self
        saturdayPicker.dataSource = self
        sundayPicker.delegate = self
        sundayPicker.dataSource = self
        cityName.delegate = self


    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        getTime()
        let week = [_sundaySelected,_mondaySelected,_tuesdaySelected,_wednesdaySelected,_thursdaySelected,_fridaySelected,_saturdaySelected]
        var city = cityName.text!
        if city == "" { city = "Default" }
        DBManager.manager.addRecycleRow(cityName: city, weekDay: week, time: [hours, minutes])
        NotificationManager.manager.scheduleWeeklyRecycleNotification(cityName: city, weekDay: week, time: [hours, minutes])
        ConnectivityManager.manager.sendBackgroundDataAsync()
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    private func getTime(){
        let date = datePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        hours = components.hour!
        minutes = components.minute!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElements[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == mondayPicker {
            _mondaySelected = pickerElements[row]
        }
        else {
            if pickerView == tuesdayPicker {
                _tuesdaySelected = pickerElements[row]
            }
            else {
                if pickerView == wednesdayPicker {
                    _wednesdaySelected = pickerElements[row]
                }
                else {
                    if pickerView == thursdayPicker {
                        _thursdaySelected = pickerElements[row]
                    }
                    else {
                        if pickerView == fridayPicker {
                            _fridaySelected = pickerElements[row]
                        }
                        else {
                            if pickerView == saturdayPicker {
                                _saturdaySelected = pickerElements[row]
                            }
                            else {
                                if pickerView == sundayPicker {
                                    _sundaySelected = pickerElements[row]
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

