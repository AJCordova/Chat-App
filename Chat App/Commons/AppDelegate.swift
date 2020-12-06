//
//  AppDelegate.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/15/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit
import Firebase
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var pubNub: PubNub!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        PubNub.log.levels = [.all]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]
        
        let config = PubNubConfiguration(publishKey: "pub-c-ab3e7382-2e56-42ab-8b17-8054bfe593df", subscribeKey: "sub-c-73714f4c-3477-11eb-bb60-1afa7ba42f78")
        pubNub = PubNub(configuration: config)
        
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

