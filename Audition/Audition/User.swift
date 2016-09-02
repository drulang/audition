//
//  User.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

class User {
    let userId:UInt
    var name:String?
    var favoriteEarthLocations:[EarthLocation] = []
    

    init(userId uid:UInt) {
        userId = uid
    }
}