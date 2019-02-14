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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            self.view.frame.origin.y -= keyboardFrame.height - 52
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    @IBAction func unwindTologinScreen(segue:UIStoryboardSegue) { }
    
    
    
}
