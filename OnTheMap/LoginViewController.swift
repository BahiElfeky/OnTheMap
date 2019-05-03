//
//  ViewController.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var share = LoginClient()
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func loginButtonAction(_ sender: Any) {
        share.loginUser(usernameLogin: emailTextField.text ?? "", passwordLogin: passwordTextField.text ?? "") { (success, errorString) in
            if (success != nil) {
                DispatchQueue.main.async {
                    self.completeLogin()
                    
                }
            } else {
               
                self.displayError("")
            }
        }
        
        
    }
    @IBAction func signUpButtonAction(_ sender: Any) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func displayError(_ error: String){
        print(error)
    }
    func login(email : String , password: String) {
        
        if email.isEmpty || password.isEmpty {
            self.displayError("Email or Password is Empty.")
        }
    }
    private func completeLogin(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NavigtaionController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }


}

