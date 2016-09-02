//
//  EarthLocation.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import Foundation

class EarthLocation {
    let coordinate:Coordinate
    var name:String?
    var alias:String?
    
    var issLocationInTheFuture:IssLocationFuture?
    
    init(coordinate:Coordinate) {
        self.coordinate = coordinate
    }
}