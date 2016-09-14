//
//  EarthService.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import CoreLocation
import Foundation

/**
 ## Mother Earth
 
 May she live forever. This class provides GeoLocation services including forward/reverse geoencoding.
 */
class EarthService {

    /**
     Forward geolocate a location on earth.
     
     - Parameter String: A name of a location.  It can be a proper address or more informal
        - NYC
        - Greensboro, NC
        - 8329 Tom Cruise Drive
     - Parameter Closure: This will be called after the encoding is complete
     */
    func forwardGeolocateLocation(_ locationName:String, withCompletion completion:@escaping (_ coordinate:Coordinate?, _ name:String?, _ error:NSError?)->Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            //TODO: (DL) Error handling, logging
            let placemark = placemarks?.first
            
            var coordinate:Coordinate?

            if let location = placemark?.location?.coordinate {
                coordinate = Coordinate(latitude: location.latitude, longitude: location.longitude)
            }
            
            completion(coordinate, placemark?.name, error as NSError?)
        }
    }
}
