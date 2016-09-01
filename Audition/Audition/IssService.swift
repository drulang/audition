//
//  IssService.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import Alamofire

import Foundation

class IssService {
 
    func nextOverheadPassPrediction(atLocation location:Location) -> IssLocationFuture {

        let parameters = [
            "lat": location.lat,  //44
            "lon": location.lon,  //30.0
            "n": 1
        ]
        
        Alamofire.request(.GET, "http://api.open-notify.org/iss-pass.json", parameters: parameters)
            .validate()
            .responseJSON { response in
                log.info("Successfully predicted next ISS overhead pass")
                log.debug(response)

                
                response
        }
        
        return IssLocationFuture()
    }
    
}