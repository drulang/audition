//
//  SystemCommand.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation

/**
## Mission Control
 
Provides the necessary services to run the CUBWO Interspace System.
 
### Subsystems

- Earth communication and dat processing
- ISS communication and location processing
- Head Quarters communication and storage pocessing
 
## Encapsulation

This class also provides encapsulations that require the coordiation
 and interaction between various subssystems
 */
class MissionControl {
    let earthService = EarthService()
    let issService = IssService()
    let hqService = HQService()
}