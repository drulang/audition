//
//  LocalService.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import CoreLocation
import Foundation

class HQService {
    
    func retrieveUser(userId:UInt, completion:(user:User, error:NSError?)->Void) {
        //TODO: Wire up to some REST API
        let user = User(userId: 8675309)
        
        let nyc = EarthLocation()
        nyc.alias = "nyc"
        nyc.location = CLLocationCoordinate2D(latitude: 40.713054, longitude: -74.007227)
        
        user.favoriteEarthLocations = [
            nyc
        ]
        
        completion(user: user, error: nil)
    }
    
}