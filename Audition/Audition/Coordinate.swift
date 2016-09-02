//
//  Coordinate.swift
//  Audition
//
//  Created by Dru Lang on 9/2/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

public typealias LocationDegrees = Double


class Coordinate {
    var longitude:LocationDegrees
    var latitude:LocationDegrees
    
    init(latitude:LocationDegrees, longitude:LocationDegrees) {
        self.longitude = longitude
        self.latitude = latitude
    }
}