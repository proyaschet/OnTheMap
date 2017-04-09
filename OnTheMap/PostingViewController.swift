//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 02/04/17.
//  Copyright © 2017 otd. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController {
    
    let dataSource = DataSource.singleton()
    let parseClient = ParseClient.singleton()
    var placemark: CLPlacemark? = nil
    var objectId : String? = nil
    @IBOutlet weak var postingMapView: MKMapView!
   // @IBOutlet weak var studyingLabel: UILabel!
   // @IBOutlet weak var topSectionView: UIView!
    //@IBOutlet weak var middleSectionView: UIView!
    //@IBOutlet weak var bottomSectionView: UIView!
    @IBOutlet weak var mapStringTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findButton:  UIButton!
    @IBOutlet weak var submitButton:  UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func cancel(_ sender : Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func findOnMap(_ sender : Any)
    {
        if mapStringTextField.text!.isEmpty
        {
            print("no input location")
        }
        
        // add activity indicator
        performUIUpdatesOnMain {
            let geocoder = CLGeocoder()
            do
            {
                geocoder.geocodeAddressString(self.mapStringTextField.text!, completionHandler: { (result, error) in
                    if let error = error
                    {
                        print("error")
                    }
                    else if(result?.isEmpty)!
                    {
                        print("no location found")
                    }
                    else
                    {
                        self.placemark = result![0]
                        self.postingMapView.showAnnotations([MKPlacemark(placemark: self.placemark!)], animated: true)
                    }
                })
            }
        }
        
    }
    
    @IBAction func submitLocation(_ sender : Any)
    {
        //activity indicator
        if mediaURLTextField.text!.isEmpty {
            //displayAlert(AppConstants.Errors.URLEmpty)
            return
        }
        guard let student = dataSource.studentLoggedIn,
            let placemark = placemark,
            let postedLocation = placemark.location else {
                //displayAlert(AppConstants.Errors.StudentAndPlacemarkEmpty)
                return
        }
        let requestCompletionHandler :(NSError?,String) -> Void = {(error , url) in
            if let _ = error
            {
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                self.dataSource.studentLoggedIn.mediaURL = url
                self.dataSource.studentLocations()
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        let location = Location(latitude: postedLocation.coordinate.latitude, longitude: postedLocation.coordinate.longitude, mapString: mapStringTextField.text!)
        
        let mediaURL = mediaURLTextField.text!
        
         if let objectID = objectId {
            let ulocation = userLocation(objectID: objectID, student: student, location: location)
            parseClient.updatingStudentLocation(objectID, mediaURL, ulocation, completionHandler: { (success, error) in
                requestCompletionHandler(error, mediaURL)
            })
        }
        else
         {
            let ulocation = userLocation(objectID: "", student: student, location: location)
            parseClient.postStudentLocation(mediaURL, ulocation, completionHandler: { (success, error) in
                requestCompletionHandler(error,mediaURL)
            })
        }
        
    }
    
    
    
    
    
}
