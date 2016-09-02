//
//  IssService.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//
import Alamofire

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
    
    func nextOverheadPassPrediction(onEarth location:EarthLocation, withCompletion completion: (futureLocation:IssLocationFuture?, error:NSError?)->Void) {
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
                let response = JSON as! NSDictionary
                let notifyAPIResponse = response.objectForKey("response")
                var futureLocation:IssLocationFuture?
                
                if  notifyAPIResponse != nil && notifyAPIResponse!.count > 0 {
                    if let risetime = notifyAPIResponse![0].objectForKey("risetime") {
                        futureLocation = IssLocationFuture(risetime: NSTimeInterval(risetime.unsignedIntegerValue))
                        log.info("Successfully predicted nextoverhead pass of ISS")
                    } else {
                        log.debug("Unable to extract a risetime at given \(location)")
                    }
                }
                
                completion(futureLocation: futureLocation, error:nil)
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                }
        }
    }
    
    /**
     Will set the
     */
    func determineNextOverheadPassPredictions(atEarthLocations locations:[EarthLocation], withCompletion completion: (futureLocation:IssLocationFuture?, error:NSError?) -> Void) {
        for earthLocation in locations {
            nextOverheadPassPrediction(onEarth: earthLocation, withCompletion: completion)
        }
    }

}