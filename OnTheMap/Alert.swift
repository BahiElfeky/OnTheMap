//
//  Alert.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 5/8/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func displayAlert(_ message : String ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
