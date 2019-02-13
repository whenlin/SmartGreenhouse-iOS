//
//  signUpScreen.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-02-12.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import UIKit

class signUpScreen: UIViewController, UITextFieldDelegate {

    //Outlets
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var invalidEmailWarning: UILabel!
    @IBOutlet weak var invalidPassword: UILabel!
    @IBOutlet weak var invalidConfirmPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.hideKeyboardWhenTappedAround() //hides keyboard
        
        self.signUpBtn.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        
        self.sendUserCredentials(completion: <#T##CompletionHandler##CompletionHandler##(Bool) -> ()#>)
        
    }
    
//    func textFieldDidChange(_ textField: UITextField) {
//        if textField == self.confirmPassword {          //enables the signup btn if confirm password box has text, disables otherwise
//
//            self.signUpBtn.isEnabled = !confirmPassword.text!.isEmpty
//            self.signUpBtn.isHidden = confirmPassword.text!.isEmpty
//        }
//    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize =  userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height - 52
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func sendUserCredentials(completion: @escaping CompletionHandler) {
        let jsonURL = URL_SIGNUP
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
        
            if let array = json["message"] as? [String] {
                print(array)
            }
            
            DispatchQueue.main.async {
                
            }
        }
        
        task.resume()
        
    }

}
