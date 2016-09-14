//
//  IssLocation.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation


class IssLocationFuture {

    var risetimeDate:Date
    let risetime:TimeInterval
    
    init(risetime rtime:TimeInterval) {
        risetime = rtime
        risetimeDate = Date(timeIntervalSince1970: rtime)
    }
}
