//
//  ViewController.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

class UserLocationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let userLoc = EarthLocation(latitude: 44, longitude: 30.0)
//        
//        IssService().nextOverheadPassPrediction(atLocation: userLoc) { (futureLocation) in
//            log.debug("Received future loc: \(futureLocation)")
//        }
        
        
        let commandCenter = SystemCommandCenter()

        commandCenter.trackNewLocation("New york, new york", alias: "NYC") { (location:EarthLocation, error:NSError) in
            
        }

//        commandCenter.earthService.forwardGeolocateLocation("New york, new york") { (location) in
//            log.debug("Recieved loc: \(location)")
//        };
        
    }
}

