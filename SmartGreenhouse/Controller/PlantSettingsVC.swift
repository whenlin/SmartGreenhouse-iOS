//
//  PlantSettingsVC.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-03-19.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import UIKit

class PlantSettingsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Outlets
    @IBOutlet weak var temperatureWarning: UILabel!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var lightLevelsInput: UIPickerView!
    
    //important variables
    var plantID: String!
    var plantName_: String!
    var lightLevels: [String] = [String]()
    var plantInfo = PlantInfo()
    var plant: Plant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lightLevelsInput.delegate = self
        self.lightLevelsInput.dataSource = self
        
       
        plantName.text = plantName_
        lightLevels = ["0","1","2","3","4","5"]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if plantID != nil {
//            self.plantInfo._id = "5c7af2458fc5ab12a77a5ed6" //for the demo
//        } else {
            self.plantInfo._id = plantID
        
//        }
        self.plantInfo.plantName = plantName_
        self.plantInfo.currentLight = " "
        self.plantInfo.currentTemperature = " "
    }
    
    func initSettingsVC(plant: Plant){
        //self.plant = plant
        self.plantName_ = plant.plantName
        self.plantID = plant.id
    }
    
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        let text = temperatureTextField.text
        let tempValue = Int(text!)
        
        if tempValue! < 0 || tempValue! > 100 {
            self.temperatureWarning.isHidden = false
        } else {
            self.temperatureWarning.isHidden = true
            self.plantInfo.currentTemperature = text
            self.plantInfo.minTemperature = "N/A"
            self.plantInfo.maxTemperature = "N/A"
            self.plantInfo.minLight = "N/A"
            self.plantInfo.maxLight = "N/A"
            self.plantInfo.minMoisture = "N/A"
            self.plantInfo.currentMoisture = "N/A"   //may change
            self.plantInfo.maxMoisture = "N/A"
        
        
            self.sendPlantInfo(plantInfo: plantInfo){
                (success) in
                if (success != nil) {
                    print(success as Any)
                } else {
                    print("Failed!")
                }
            }
            
            dismiss(animated: true, completion: nil)
        
        }
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
    
    //sends the update plant data
    func sendPlantInfo(plantInfo: PlantInfo, completion:((Error?) -> Void)?){
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "smart-greenhouse-rest-api-whenlin.c9users.io"
        urlComponents.port = 8080
        urlComponents.path = "/updatePlantInfo/" + plantID
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(plantInfo)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
        }
        task.resume()
        
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
