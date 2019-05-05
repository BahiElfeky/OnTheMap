//
//  NavigationBarViewController.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit

class NavigationBarViewController: UITabBarController {
    
    let mapViewClient = MapViewClient()
    @IBOutlet weak var addNewPin: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBAction func logoutAction(_ sender: Any) {
        
        UtlisFunctions.resetDefaults()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        
    }
    
    @IBAction func addNewPinAction(_ sender: Any) {
        let cont = storyboard?.instantiateViewController(withIdentifier: "AddPinNavigation") as! UINavigationController
        self.present(cont, animated: true, completion: nil)
    }
    
}
