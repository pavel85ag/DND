//  test changes
//  AppDelegate.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 9/6/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
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
        
        loadDefaults()
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        print("will resign")
        updateDefaults()
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("will terminate")
        updateDefaults()
      
    }


}

