//
//  PlantProfile.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-02-12.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import UIKit

class PlantProfile: UIViewController {

    //Outlets
    @IBOutlet weak var plantNameLabel: UILabel!
    
    @IBOutlet weak var plantImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var lightLabel: UILabel!
    
    @IBOutlet weak var moistureLabel: UILabel!
    
    //important variables
    var plantName:  String!
    var plantID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantNameLabel.text = plantName
        
        self.fetchPlantInfo() {
            (error) in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                print("Success!!!")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.fetchPlantInfo() {
            (error) in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                print("Success!!!")
            }
        }
    }
    
    func initPlantProfile(plant: Plant){ //initializes this VC's info
        plantName = plant.plantName
        plantID = plant.id
    }
    
    @IBAction func changeSettingsBtnClicked(_ sender: Any) {
        let plant = Plant(_id: plantID, plantName: plantName)
        performSegue(withIdentifier: "toPlantSettings", sender: plant)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchPlantInfo(completion:((Error?) -> Void)?) {
        
        var urlComponents = URLComponents()     //should change this IP ADDRESS TO RASPBERRY PI'S
        urlComponents.scheme = "http"  //change to http when going to the pi
        urlComponents.host = "172.20.10.2"    //"192.168.2.20" //change to pi IP address
        urlComponents.port = 3000
        urlComponents.path = "/retrievePlantInfo/" + plantID
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a GET method
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            
            // APIs usually respond with the data you just sent in your GET request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
            
            guard let plantInfo = try? JSONDecoder().decode(PlantInfo.self, from: responseData!) else {
                print("Error: Couldn't decode data into Reviews")
                return
            }
            
            DispatchQueue.main.async {
                self.temperatureLabel.text = plantInfo.currentTemperature
                self.lightLabel.text = plantInfo.currentLight
            }
            
        }
        task.resume()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let plantSettings = segue.destination as? PlantSettingsVC{
            assert(sender as? Plant != nil)
            plantSettings.initSettingsVC(plant: sender as! Plant)
        }
    }
 

}
