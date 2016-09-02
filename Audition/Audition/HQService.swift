//
//  LocalService.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import Foundation

class HQService {
    
    func retrieveUser(userId:UInt, completion:(user:User, error:NSError?)->Void) {
        //TODO: Wire up to some REST API
        let user = User(userId: 8675309)
        
        let nycCoordinate = Coordinate(latitude: 40.713054, longitude: -74.007227)
        let nyc = EarthLocation(coordinate: nycCoordinate)
        nyc.issLocationInTheFuture = IssLocationFuture(risetime: 1472787130)
        nyc.alias = "nyc"
        
        user.favoriteEarthLocations = [
            nyc
        ]
        
        completion(user: user, error: nil)
    }
    
}