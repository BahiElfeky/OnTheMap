//
//  AddNewLocationController.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 5/2/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddNewLocationController: UIViewController {
    var lat = 0.0
    var lng = 0.0
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBAction func findLocationAction(_ sender: Any) {
        guard !locationTextField.text!.isEmpty, !linkTextField.text!.isEmpty else {
//            self.showAlert(message: "Loacation or Link fields are empty")
            print("Loacation or Link fields are empty ")
            return
        }
        checkLocation(address: locationTextField.text!) { (success, message, error) in
            if success == true {
                DispatchQueue.main.async {
//                    self.activityView.stopAnimating()
                    self.performSegue(withIdentifier: "sendLocation", sender: self)
                }
            }
        }
    }
        func checkLocation(address: String?, completionHandler: @escaping (_ result: Bool, _ message: String, _ error: Error?)->()){
            let geoCoder = CLGeocoder()
            if let mapString = address {
                geoCoder.geocodeAddressString(mapString) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        else {
//                            self.showAlert(message: "Cannot Find Location")
                            print("Cannot Find Location")
                            completionHandler(false, "Cannot Find Location", error)
                            return
                    }
                    
                    self.lat = location.coordinate.latitude
                    self.lng = location.coordinate.longitude
                    if(self.lat != 0.0 && self.lng != 0.0){
                        completionHandler(true, "", nil)}
                    
                }
            }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LocationViewController
        vc.location = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
        vc.locationString = locationTextField.text
        vc.urlString = linkTextField.text
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
