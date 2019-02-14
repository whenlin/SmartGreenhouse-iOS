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
    
    //Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.hideKeyboardWhenTappedAround() //hides keyboard
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    
     func signUpClicked() {
        
        if(!(userEmail.text!.isEmpty) && (passwordField.text!.elementsEqual(confirmPassword.text!))){
            var user = UserInfoToSend()
            user.username = userEmail.text!
            user.password = passwordField.text!
            
            sendUserInfo(theUser: user){
                (success) in
                if success {
                    print("Worked!")
                } else {
                    print("Failed!")
                }
            }
        } else if(userEmail.text!.isEmpty){
            //when email field is empty
            
        } else if(passwordField.text != confirmPassword.text){
            //when passwords dont match
            
        }
    }
    
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField == self.confirmPassword {          //enables the signup btn if confirm password box has text, disables otherwise

            self.signUpBtn.isEnabled = !confirmPassword.text!.isEmpty
            self.signUpBtn.isHidden = confirmPassword.text!.isEmpty
        }
    }
    
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
    
    @IBAction func unwindTologinScreen(segue: UIStoryboardSegue) {
        print("Unwinding to Login Screen")
        signUpClicked()
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    func sendUserInfo(theUser: UserInfoToSend,completion: @escaping CompletionHandler){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "smart-greenhouse-rest-api-whenlin.c9users.io"
        urlComponents.port = 8080
        urlComponents.path = "/createUser"
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
            let jsonData = try encoder.encode(theUser)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion(error as! Bool)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion(responseError! as! Bool)
                return
            }
        }
        task.resume()
    }
    
    

}
