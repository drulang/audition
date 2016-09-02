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

    func forwardGeolocateLocation(locationName:String, withCompletion completion:(coordinate:Coordinate?, name:String?, error:NSError?)->Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            //TODO: (DL) Error handling, logging
            let placemark = placemarks?.first
            
            var coordinate:Coordinate?

            if let location = placemark?.location?.coordinate {
                coordinate = Coordinate(latitude: location.latitude, longitude: location.longitude)
            }
            
            completion(coordinate: coordinate, name: placemark?.name, error: error)
        }
    }
}