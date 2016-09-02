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

    func forwardGeolocateLocation(locationName:String, withCompletion completion:(coordinate:Coordinate?)->Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            //TODO: (DL) Error handling, logging
            if let location = placemarks?.first?.location?.coordinate {
                let coordinate = Coordinate(latitude: location.latitude, longitude: location.longitude)
                completion(coordinate: coordinate)
            } else {
                completion(coordinate: nil)
            }
        }
    }
}