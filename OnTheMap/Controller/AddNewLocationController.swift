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
    
    var activityView = UIActivityIndicatorView(style: .gray)
    var lat = 0.0
    var lng = 0.0
    var keyboard = Keyboard()
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboard.configureTextField(textField: locationTextField!)
        keyboard.configureTextField(textField: linkTextField!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboard.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboard.unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func findLocationAction(_ sender: Any) {
        showActivityIndicatory()
        guard !locationTextField.text!.isEmpty, !linkTextField.text!.isEmpty else {
            self.displayAlert("Loacation or Link fields are empty ")
            return
        }
        checkLocation(address: locationTextField.text!) { (success, message, error) in
            if success == true {
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
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
//                        print("Cannot Find Location")
                        completionHandler(false, "Error! fining location", error)
                        self.displayAlert("Cannot Find Location")
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
    
    func showActivityIndicatory() {
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
}
