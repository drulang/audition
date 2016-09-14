//
//  AppDelegate.swift
//  Audition
//
//  Created by Dru Lang on 9/1/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

import SwiftyBeaver


let log = SwiftyBeaver.self


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Use dependency injection
    fileprivate let missionControl = MissionControl()
    
    var user:User?// TODO: (DL) Rethink this, feels like it might belong in MissionControl

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initializeLogging()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //TODO: If this were real I would go about this in a very different manner.  I would probably have some sort of RootController class
        // that would be set to window.rootVC and then within RootController provide the logic and mechanisms for loading the first screen
        // based on the current app state.
        missionControl.hqService.retrieveUser(8675309, completion: { (user, error) in
            self.user = user

            let rootViewController = UserLocationsViewController(missionControl: self.missionControl, user: user)

            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
        })

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate {
    
    /// Setup system logging facility
    func initializeLogging() {
        log.addDestination(ConsoleDestination())
    }
    
}

