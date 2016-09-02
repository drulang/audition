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
            static let limit:AnyObject = 1
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
    
    func nextOverheadPassPrediction(onEarth location:EarthLocation, withCompletion completion: (futureLocation:IssLocationFuture?, error:NSError?)->Void) {
        let parameters = [
            IssServiceConfig.Parameter.latitude: location.coordinate.latitude,
            IssServiceConfig.Parameter.longitude: location.coordinate.longitude,
            IssServiceConfig.Parameter.limit: IssServiceConfig.Parameter.Value.limit
        ]
        
        Alamofire.request(.GET, IssServiceConfig.Paths.prediction, parameters: parameters)
            .validate()
            .responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                let response = JSON as! NSDictionary
                let notifyAPIResponse = response.objectForKey(IssServiceConfig.ResponseKey.response)
                var futureLocation:IssLocationFuture?
                
                if  notifyAPIResponse != nil && notifyAPIResponse!.count > 0 {
                    if let risetime = notifyAPIResponse![0].objectForKey(IssServiceConfig.ResponseKey.risetime) {
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

    func determineNextOverheadPassPredictions(atEarthLocations locations:[EarthLocation], withCompletion completion: (futureLocation:IssLocationFuture?, error:NSError?) -> Void) {
        for earthLocation in locations {
            nextOverheadPassPrediction(onEarth: earthLocation, withCompletion: completion)
        }
    }

}