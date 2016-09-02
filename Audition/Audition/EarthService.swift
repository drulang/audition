//
//  EarthService.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import CoreLocation
import Foundation

class EarthService {

    func forwardGeolocateLocation(locationName:String, withCompletion completion:(coordinate:CLLocationCoordinate2D?)->Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            //TODO: (DL) Error handling, logging
            if let location = placemarks?.first?.location?.coordinate {
                completion(coordinate: location)
            } else {
                completion(coordinate: nil)
            }
        }
    }
}