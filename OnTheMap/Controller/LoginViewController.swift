//
//  ViewController.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var keyboard = Keyboard()
    var share = LoginClient()
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func loginButtonAction(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.displayAlert("Please enter your username and password.")
        }
        else {
        share.loginUser(usernameLogin: emailTextField.text!, passwordLogin: passwordTextField.text!) { (success,message,errorString) in
            if (success != nil)
            {
                DispatchQueue.main.async {
                    self.completeLogin()
                }
            } else {
                if message!.contains("2xx"){
                    self.displayAlert ("Invalid email or password")
                }
                else if message != nil {
                    self.displayAlert ("Please check your internet connection")
                }
                
            }
        }
        }
        
    }
    @IBAction func signUpButtonAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboard.configureTextField(textField: emailTextField!)
        keyboard.configureTextField(textField: passwordTextField!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboard.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboard.unsubscribeFromKeyboardNotifications()
    }
    
    private func completeLogin(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NavigtaionController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
}

