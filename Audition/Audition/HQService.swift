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
        //TODO: Wire up to some REST API/LocalDB/Space station
        let user = User(userId: userId)

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