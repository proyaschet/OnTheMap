//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 08/04/17.
//  Copyright © 2017 otd. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    
    let datasource = DataSource.singleton()
    
    @IBOutlet weak var mapView : MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
          mapView.delegate = self
                    NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsDidUpdate), name: NSNotification.Name(rawValue: "\(ParseClient.urlMethod.studentLocation)\(ParseClient.Notifications.ObjectUpdated)"), object: nil)
        
        datasource.studentLocations()
      
        // Do any additional setup after loading the view.
    }
    
    func studentLocationsDidUpdate()
    {
        var annotations = [MKPointAnnotation]()
        for userLocation in datasource.student
        {
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation.location.coordinate
            annotation.title = userLocation.student.fullName
            annotation.subtitle = userLocation.student.mediaURL
            annotations.append(annotation)
        }
        
        self.performUIUpdatesOnMain {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
            
        }
    }
    

}


extension MapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "Pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = URL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.shared.canOpenURL(mediaURL) {
                    UIApplication.shared.openURL(mediaURL)
                } else {
                    print("cannot open url")
                }
            }
        }
    }

}
