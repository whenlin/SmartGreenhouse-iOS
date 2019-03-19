//
//  PlantMenu.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-02-12.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import UIKit

class PlantMenu: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Outlets
    @IBOutlet weak var listOfPlants: UITableView!
    
    
    //properties
    var tableData: [Plant] = [Plant]()
    var plantNamesAndID: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfPlants.dataSource = self
        listOfPlants.delegate = self
        
        self.tableData = getPlantList()
        
        
    }
    
    func getPlantList() -> [Plant] {  //gets data from api then returns array
        //Implement code here
        
        tableData = retrievePlants(){
            (success) in
            if success {
                print("Worked!")
            } else {
                print("Failed!")
            }
        }
        return tableData
    }
    
    func retrievePlants(completion: @escaping CompletionHandler) -> [Plant] {
        
        let jsonURL = URL_GETPLANTS
        let url = URL(string: jsonURL)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error ) in
            
            guard error == nil else {
                print("returned error")
                return
            }
            
            guard let content = data else {
                print("No data")
                return
            }
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            if let array = json["plants"] as? [String] {
                self.plantNamesAndID = array
            } //inserts plants received from server to local array
            
            var counter = 0
            var plantNameToAdd = ""
            var plantIDtoAdd = ""
            
            for index in self.plantNamesAndID {
                
                if counter%2 == 0 {
                    plantNameToAdd = index
                } else {
                    plantIDtoAdd = index
                    self.tableData.append(Plant(_id: plantIDtoAdd, plantName: plantNameToAdd))
                }
                
                counter+=1
            } //loads info received into table's array
            
            DispatchQueue.main.async {
                self.listOfPlants.reloadData()
            }
            
        }
        
        task.resume()
        
        return tableData
    }
    
    func getTableData() -> [Plant] {
        
        if tableData.count == 0{
            return [Plant]()
        }
        
        return tableData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getTableData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell") as? PlantCell{
            let plant_ = self.getTableData()[indexPath.row]
            cell.updateViews(plant: plant_)  //updates plant names only at the moment
            return cell
        } else {
            return PlantCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plant = self.getTableData()[indexPath.row]
        performSegue(withIdentifier: "toPlantProfile", sender: plant)
    }
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let plantProfiles = segue.destination as? PlantProfile{
            assert(sender as? Plant != nil)
            //var info = Plant(_id: <#T##String#>, plantName: <#T##String#>)
            plantProfiles.initPlantProfile(plant: sender as! Plant)
        }
        
    }
 

}
