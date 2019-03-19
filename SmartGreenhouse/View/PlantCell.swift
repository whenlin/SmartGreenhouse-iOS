//
//  PlantCell.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-03-02.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import UIKit

class PlantCell: UITableViewCell {

    @IBOutlet weak var plantName: UILabel!
    var plantID: String!
    
    func updateViews(plant: Plant){
        plantName.text = plant.plantName
        plantID = plant.id
    }

}
