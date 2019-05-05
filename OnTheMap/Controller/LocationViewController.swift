//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 5/2/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController , MKMapViewDelegate {
    
    var location : CLLocationCoordinate2D!
    var urlString : String!
    var locationString : String!
    var annotations = [MKPointAnnotation]()
    var mapViewClient = MapViewClient()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        
        if let locationString = locationString, let urlLink = urlString  {
            if let lat = location?.latitude, let lng =  location?.longitude {
                let studentLocation =  setStudentInfo(lat: lat, lng: lng, mapString: locationString, urlLink: urlLink)
                
                mapViewClient.postStudentLocation(studentLocation: studentLocation) { (success, message, error) in
                    if success == true {
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        if error != nil || !message.isEmpty {
                            print(message)
                        }
                    }
                }
                
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //mapView.reloadInputViews()
        print("location is \(String(describing: location))")
        if location?.latitude  != 0.0 && location?.longitude != 0.0 {
            
            addPin()
        }
    }

    func addPin(){
        let annotation = MKPointAnnotation()
        if let location = location{
            if let urlLink = urlString{
                annotation.coordinate = location
                annotation.subtitle = urlLink
                
                self.annotations.append(annotation)
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(self.annotations)
                }
                self.mapView.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(NSURL(string: toOpen)! as URL)
            }
        }
    }
    
    func setStudentInfo (lat: Double, lng: Double, mapString: String, urlLink: String) -> StudentInfo{
        let student = StudentInfo([Constants.firstName: "Bahi", Constants.lastName: "Elfeky", Constants.Latitude: lat, Constants.Longitude: lng, Constants.MapString: mapString, Constants.MediaURL: urlLink, Constants.SessionID: UtlisFunctions.getDataFromUserDefault(key: "usersessionid"), Constants.UpdateAt: ""])
        return student
    }
}
