//
//  IssLocation.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

class IssLocationFuture {
    var risetimeDate:NSDate
    let risetime:NSTimeInterval
    
    init(risetime rtime:NSTimeInterval) {
        risetime = rtime
        risetimeDate = NSDate(timeIntervalSince1970: rtime)
    }
}