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
    
    struct Parameter {
        static let predctionResponseLimit:Int = 1
        static let latitude = "lat"
        static let longitude = "lon"
        static let limit = "n"
        
        struct Value {
            static let limit:AnyObject = 1 as AnyObject
        }
    }
    
    struct ResponseKey {
        static let response = "response"
        static let risetime = "risetime"
    }
    
}


/**
 International Space Stationg
 
 Provides communication with ISS
 */
class IssService {
    
    func nextOverheadPassPrediction(onEarth location:EarthLocation, withCompletion completion: @escaping (_ futureLocation:IssLocationFuture?, _ error:NSError?)->Void) {
        let parameters = [
            IssServiceConfig.Parameter.latitude: location.coordinate.latitude,
            IssServiceConfig.Parameter.longitude: location.coordinate.longitude,
            IssServiceConfig.Parameter.limit: IssServiceConfig.Parameter.Value.limit
        ] as [String : Any]
        
        
        Alamofire.request(IssServiceConfig.Paths.prediction, parameters: parameters)
            .responseJSON { response in
                if let JSON = response.result.value as? NSDictionary {
                    let notifyAPIResponse = JSON.object(forKey: IssServiceConfig.ResponseKey.response) as? NSArray
                    var futureLocation:IssLocationFuture?
                    
                    if  notifyAPIResponse != nil && notifyAPIResponse!.count > 0 {
                        if let firstObject = notifyAPIResponse![0] as? NSDictionary {
                            if let risetime = firstObject.object(forKey: IssServiceConfig.ResponseKey.risetime) as? NSNumber {
                                futureLocation = IssLocationFuture(risetime: TimeInterval(risetime.uintValue))
                                log.info("Successfully predicted nextoverhead pass of ISS")
                            } else {
                                log.debug("Unable to extract a risetime at given \(location)")
                            }
                        }
                    }
                    completion(futureLocation, nil)
                }
        }
    }

    func determineNextOverheadPassPredictions(atEarthLocations locations:[EarthLocation], withCompletion completion: @escaping (_ futureLocation:IssLocationFuture?, _ error:NSError?) -> Void) {
        for earthLocation in locations {
            nextOverheadPassPrediction(onEarth: earthLocation, withCompletion: completion)
        }
    }

}
