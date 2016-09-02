//
//  IssLocation.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

class IssLocation: Location {
    
}

//TODO: Might want to rename this, a bit confusing since it doesn't subclass Location
class IssLocationFuture {
    var risetimeDate:NSDate?
    let risetime:UInt
    
    init(risetime rtime:UInt) {
        risetime = rtime
    }
}