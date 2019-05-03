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
//        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
                    //                        showAlert(message: "Failed to download students locations")
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                let identifier = "pin"
        
                var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
                if pinView == nil {
                    pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
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
    

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let identifier = "pin"
//
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
//
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            pinView!.canShowCallout = true
//            pinView!.pinTintColor = .red
//            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        else {
//            pinView!.annotation = annotation
//        }
//
//        return pinView
//    }
//
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            if let toOpen = view.annotation?.subtitle! {
//                UIApplication.shared.open(NSURL(string: toOpen)! as URL)
//            }
//        }
//    }

    
    
}
