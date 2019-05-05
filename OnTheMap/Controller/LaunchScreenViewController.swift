//
//  LaunchScreenViewController.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UtlisFunctions.getFromUserDefault(key: "userkey"){
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "NavigtaionController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        } else {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! UIViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
}
