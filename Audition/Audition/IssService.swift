//
//  IssService.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import Alamofire

import CoreLocation
import Foundation

private struct IssServiceConfig {
    static let host = "http://api.open-notify.org"
    
    struct Paths {
        static let prediction = "\(IssServiceConfig.host)/iss-pass.json"
    }
    
    struct Parameters {
        static let predctionResponseLimit:Int = 1
    }
}


class IssService {
    
    func nextOverheadPassPrediction(onEarth location:EarthLocation, withCompletion completion: (futureLocation:IssLocationFuture?)->Void) {
        let parameters = [
            "lat": location.coordinate.latitude,
            "lon": location.coordinate.longitude,
            "n": 1
        ]
        
        Alamofire.request(.GET, IssServiceConfig.Paths.prediction, parameters: parameters)
            .validate()
            .responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                log.info("Successfully predicted nextoverhead pass of ISS")

                let response = JSON as! NSDictionary
                
                if let notifyAPIResponse = response.objectForKey("response") {
                    if let risetime = notifyAPIResponse[0].objectForKey("risetime") {
                        let futureLocation = IssLocationFuture(risetime: NSTimeInterval(risetime.unsignedIntegerValue))
                        completion(futureLocation: futureLocation)
                    } else {
                        log.debug("Unable to extract a risetime at given \(location)")
                        completion(futureLocation: nil)
                    }
                }
                

            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }
        
    }

}