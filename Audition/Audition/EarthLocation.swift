//
//  EarthLocation.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import CoreLocation
import Foundation

class EarthLocation {
    let coordinate:CLLocationCoordinate2D
    var name:String?
    var alias:String?
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}