//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Bahi El Feky on 4/29/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    var mapViewClient = MapViewClient()
    @IBOutlet var mapView: MKMapView!
    var pointAnnotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapViewClient.getStudent { (data, error ) in
            if (data != nil) {
                //
                let studentLocations = data;
                
                for studentLocation in studentLocations as! [StudentInfo] {
                    
                    let lat = CLLocationDegrees(studentLocation.latitude)
                    let lng = CLLocationDegrees(studentLocation.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    let firstName = studentLocation.firstName!
                    let lastName = studentLocation.lastName!
                    let mediaURL = studentLocation.mediaURL!
                    
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = coordinate
                    pointAnnotation.title = "\(firstName) \(lastName))"
                    pointAnnotation.subtitle = mediaURL
                    
                    self.pointAnnotations.append(pointAnnotation)
                    
                }
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(self.pointAnnotations)
                }
            }
            else {
                if error != nil{
                    self.displayAlert("Faild to load!")
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pin!.canShowCallout = true
            pin!.pinTintColor = .red
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pin!.annotation = annotation
        }
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(NSURL(string: toOpen)! as URL)
            }
        }
        
    }
    
}
