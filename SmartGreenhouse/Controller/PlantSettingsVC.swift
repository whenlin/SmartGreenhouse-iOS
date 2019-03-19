//
//  PlantSettingsVC.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-03-19.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import UIKit

class PlantSettingsVC: UIViewController {

    //Outlets
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var lightLevelsInput: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func submitBtnClicked(_ sender: Any) {
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
