//
//  AddPlantVC.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-03-20.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import UIKit

class AddPlantVC: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var plantName: UITextField!
    
    @IBOutlet weak var temperature: UITextField!
    
    @IBOutlet weak var lightLevel: UIPickerView!
    
    //Variables
    var plantID: String!
    var plantName_: String!
    var lightLevels: [String] = [String]()
    var plantInfo = PlantInfo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lightLevels = ["0","1","2","3","4","5"]
        
        self.lightLevel.delegate = self
        self.lightLevel.dataSource = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        plantInfo.currentLight = lightLevels[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lightLevels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lightLevels[row]
    }

    @IBAction func enterBtnClicked(_ sender: Any) {
        if plantName.text!.count > 0 && temperature.text!.count > 0 {
            plantInfo.plantName = plantName.text
            plantInfo.currentTemperature = temperature.text
            plantInfo.minTemperature = "N/A"
            plantInfo.maxTemperature = "N/A"
            plantInfo.minMoisture = "N/A"
            plantInfo.currentMoisture = "N/A"
            plantInfo.maxMoisture = "N/A"
            plantInfo.minLight = "N/A"

            plantInfo.maxLight = "N/A"
            
            
            
        }
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
