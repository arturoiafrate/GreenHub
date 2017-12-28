//
//  AddPlantViewController.swift
//  GreenHub
//
//  Created by Arturo Iafrate on 01/08/17.
//  Copyright © 2017 Arturo Iafrate. All rights reserved.
//

import Foundation
import UIKit

class AddPlantViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var plantName: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantDescription: UITextField!
    
    private var _categorySelected = "Aromatics"
    private let pickerElements: [String] = ["Aromatics", "Bonsai", "Water-retainig"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
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
        if pickerView == categoryPicker {
            _categorySelected = pickerElements[row]
        }
    }
    
    @IBAction func insertNewPlant(_ sender: UIBarButtonItem) {
        var plant = plantName.text!
        if plant == "" { plant = "Default" }
        let toInsert = [plant, _categorySelected, plantDescription.text!]
        let imageData = UIImagePNGRepresentation(plantImage.image!)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        let img = plantImage.image
        DBManager.manager.addPlantRow(plant: toInsert, image: img!)
        NotificationManager.manager.schedulePlantNotification(plant: toInsert)
        ConnectivityManager.manager.sendBackgroundDataAsync()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takeAPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
   
    @IBAction func importAPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            plantImage.contentMode = .scaleToFill
            plantImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
