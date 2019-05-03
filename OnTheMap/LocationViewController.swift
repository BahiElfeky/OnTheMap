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
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        
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
                annotation.title = "----"
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
}
