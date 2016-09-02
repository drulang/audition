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
 
    func nextOverheadPassPrediction(atLocation location:Location) {

        let parameters = [
            "lat": location.lat,
            "lon": location.lon,
            "n": 1
        ]
        
        Alamofire.request(.GET, "http://api.open-notify.org/iss-pass.json", parameters: parameters)
            .validate()
            .responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                log.info("Successfully predicted nextoverhead pass of ISS")

                let response = JSON as! NSDictionary
                
                if let notifyAPIResponse = response.objectForKey("response") {
                    if let risetime = notifyAPIResponse[0].objectForKey("risetime") {
                        let futureLocation = IssLocationFuture(risetime: risetime.unsignedIntegerValue)
                    } else {
                        log.debug("Unable to extract a risetime at given \(location)")
                    }
                }
                

            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }
        
    }
    
    
}