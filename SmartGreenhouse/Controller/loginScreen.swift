//
//  loginScreen.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-02-12.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import UIKit

class loginScreen: UIViewController {

    //Outlets
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var failedLoginLabel: UILabel!
    
    
    var loginSuccessful = false //boolean to keep track of whether login was successful or not
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginSuccessful = false
        
        self.hideKeyboardWhenTappedAround() //hides keyboard
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
            self.view.frame.origin.y -= keyboardFrame.height - 56
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        failedLoginLabel.isHidden = true
        
        var userInfo = UserInfoToSend()
        userInfo.username = userName.text
        userInfo.password = password.text
        
        THE BLOCK BELOW IS COMMENTED OUT TEMPORARILY TO WORK ON PLANT MENU ETC
        REMEMBER TO UNCOMMENT THE BLOCK
        loginSuccessful = sendLoginInfo(theUser: userInfo){
            (success) in
            if (success != nil) {
                print(success as Any)
            } else {
                print("Login Failed!")
            }
        }
        
        
        if loginSuccessful {
            performSegue(withIdentifier: "toPlantMenu", sender: self)
        } else {
            failedLoginLabel.isHidden = false
        }
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
            self.performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    @IBAction func unwindTologinScreen(segue:UIStoryboardSegue) { }
    
    
    func sendLoginInfo(theUser: UserInfoToSend,completion: @escaping CompletionHandler) -> Bool{
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "smart-greenhouse-rest-api-whenlin.c9users.io"
        urlComponents.port = 8080
        urlComponents.path = "/signIn"
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
            
            // APIs usually respond with the data you just sent in your POST request
                    if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                        print("response: ", utf8Representation)
                    } else {
                        print("no readable data received in response")
                    }
            
                    guard let loginResult = try? JSONDecoder().decode(UserLoginResult.self, from: responseData!) else {
                        print("Error: Couldn't decode data into Ratings array")
                        return
                    }
            
            let userResult = loginResult.result
            
            if userResult == "Success" {
                self.loginSuccessful = true
            }
            
        }
        
        task.resume()
        
        return loginSuccessful
    }
    
}
