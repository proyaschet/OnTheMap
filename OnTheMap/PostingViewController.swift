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
    @IBOutlet weak var mapStringTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var findButton:  UIButton!
    @IBOutlet weak var submitButton:  UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapStringTextField.delegate = self
        mediaURLTextField.delegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activityIndicator.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        
    }

    
    @IBAction func cancel(_ sender : Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func findOnMap(_ sender : Any)
    {
        acticityIndicatorConfiguration(state: true)
        if mapStringTextField.text!.isEmpty
        {
            displayAlert("NO INPUT LOCATION")
           acticityIndicatorConfiguration(state: false)
        }
        
        
        performUIUpdatesOnMain {
            let geocoder = CLGeocoder()
            do
            {
                geocoder.geocodeAddressString(self.mapStringTextField.text!, completionHandler: { (result, error) in
                    if let error = error
                    {
                       self.displayAlert("error")
                        //self.activityIndicator.stopAnimating()
                        self.acticityIndicatorConfiguration(state: false)
                    }
                    else if(result?.isEmpty)!
                    {
                        self.displayAlert("no location found")
                        //print("no location found")
                        //self.activityIndicator.stopAnimating()
                          self.acticityIndicatorConfiguration(state: false)
                    }
                    else
                    {
                        self.placemark = result![0]
                        self.postingMapView.showAnnotations([MKPlacemark(placemark: self.placemark!)], animated: true)
                        //self.activityIndicator.stopAnimating()
                        self.acticityIndicatorConfiguration(state: false)
                    }
                })
            }
        }
        
    }
    
    @IBAction func submitLocation(_ sender : Any)
    {
        self.acticityIndicatorConfiguration(state: true)
        if mediaURLTextField.text!.isEmpty {
            displayAlert(Errors.URLEmpty)
            self.acticityIndicatorConfiguration(state: false)
            return
        }
        guard let student = dataSource.studentLoggedIn,
            let placemark = placemark,
            let postedLocation = placemark.location else {
                displayAlert("StudentAndPlacemarkEmpty")
                self.acticityIndicatorConfiguration(state: false)
                return
        }
        let requestCompletionHandler :(NSError?,String) -> Void = {(error , url) in
            if let _ = error
            {
                self.acticityIndicatorConfiguration(state: false)
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                self.dataSource.studentLoggedIn.mediaURL = url
                self.dataSource.studentLocations()
            self.acticityIndicatorConfiguration(state: false)
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
    func displayAlert(_ message: String, completionHandler: ((UIAlertAction) -> Void)? = nil) {
        self.performUIUpdatesOnMain{
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: completionHandler))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func acticityIndicatorConfiguration(state : Bool)
    {
        if(state == true)
        {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        else
        {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }

    
    
    
    
}

extension PostingViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
}
}

