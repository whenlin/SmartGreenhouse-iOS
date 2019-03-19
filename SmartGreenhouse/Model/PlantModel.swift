//
//  PlantModel.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-02-17.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import Foundation

struct PlantInfo: Encodable, Decodable{
    
    var _id: String!
    var plantName: String!
    var plantType: String!
    var minTemperature: String! //the temp that the user set from their mobile app
    var currentTemperature: String!
    var maxTemperature: String!
    var minMoisture: String!    //the moisture setting that the user set from their mobile app
    var currentMoisture: String!
    var maxMoisture: String!
    var minLight: String!
    var currentLight: String!
    var maxLight: String //the light setting that the user set from their mobile app
    
    init(){
        
        self._id = " "
        self.plantName = " ";
        self.plantType = " ";
        self.minTemperature = "N/A";
        self.currentTemperature = "N/A";
        self.maxTemperature = "N/A";
        self.minMoisture = "N/A";
        self.currentMoisture = "N/A";
        self.maxMoisture = "N/A";
        self.minLight = "N/A";
        self.currentLight = "N/A";
        self.maxLight = "N/A";
    }
}

class Plant {
    
    public var id: String
    public var plantName: String
    
    init(_id: String, plantName: String){
        self.id = _id
        self.plantName = plantName
    }
    
}
