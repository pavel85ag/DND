//  test changes
//  AppDelegate.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 9/6/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
import CoreData
import FlickrKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let scheme = url.scheme
        if("flickrkitdemo" == scheme) {
            // I don't recommend doing it like this, it's just a demo... I use an authentication
            // controller singleton object in my projects
            NotificationCenter.default.post(name: Notification.Name(rawValue: "UserAuthCallbackNotification"), object: url)
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialise FlickrKit with your flickr api key and shared secret
        let apiKey: String! = "ef132be53a6edbc6027fefc9e556cd25"
        let secret: String! = "6bbb9f48142f3400"
        if (apiKey == nil || secret == nil) {
            print("\n----------------------------------\nYou need to enter your own 'apiKey' and 'secret' in FKAppDelegate for the demo to run. \n\nYou can get these from your Flickr account settings.\n----------------------------------\n");
            exit(0);
        } else {
            FlickrKit.shared().initialize(withAPIKey: apiKey, sharedSecret: secret)
        }
        
       // loadDefaults()
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        
       // updateDefaults()
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
       // updateDefaults()
      
    }
    

}

