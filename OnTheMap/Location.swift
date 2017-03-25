//
//  Location.swift
//  OnTheMap
//
//  Created by Amarnath Manipatra on 25/03/17.
//  Copyright © 2017 otd. All rights reserved.
//


import MapKit


struct Location {
    
    let latitude: Double
    let longitude: Double
    let mapString: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}
