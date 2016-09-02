//
//  LocalService.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import Foundation

/**
 Headquarters aka The Mother Ship.  Use this class to interact with HQ personel, preferences,
 updating a user, etc
 */
class HQService {
    
    /**
     Retrieve a user working at HQ
     
     - Parameter Unsigned Int: A valid user id
     
     - Returns: A User object
     */
    func retrieveUser(userId:UInt, completion:(user:User, error:NSError?)->Void) {
        //TODO: user should be optional
        //NOTE: Wire up to some REST API/LocalDB/Space station
        let user = User(userId: userId)
        user.name = "Chief Bob"
        let nycCoordinate = Coordinate(latitude: 40.713054, longitude: -74.007227)
        let nyc = EarthLocation(coordinate: nycCoordinate)
        nyc.name = "New York, New York"
        nyc.alias = "NYC"
        
        user.favoriteEarthLocations = [
            nyc
        ]
        
        completion(user: user, error: nil)
    }
    
}