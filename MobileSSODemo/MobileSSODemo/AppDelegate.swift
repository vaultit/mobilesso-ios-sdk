//
//  AppDelegate.swift
//  MobileSSODemo
//
//  Created by Antti Laitinen on 21/02/2017.
//  Copyright © 2017 VaultIT. All rights reserved.
//

import UIKit
import AppAuth
import MobileSSOFramework
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, VITMobileSSOAppDelegate {

    var window: UIWindow?

    var currentAuthFlow: OIDAuthorizationFlowSession?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // This is used for clearing the state for automated testing.
        if ProcessInfo.processInfo.arguments.contains("deleteData") {
            VITMobileSSO.deleteAllData()
        }
        
        // This call is required to acquire the initial session state.
        VITMobileSSO.initializeSDK()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // This needs to be called to keep session state updated.
        VITMobileSSO.willEnterForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Sends the URL to the current authorization flow (if any) which will process it if it relates to
        // an authorization response.
        if currentAuthFlow?.resumeAuthorizationFlow(with: url) ?? false {
            currentAuthFlow = nil
            return true
        }
        
        return false;
    }

}

