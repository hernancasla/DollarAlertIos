//
//  AppDelegate.swift
//  DollarAlert
//
//  Created by Osvaldo Ceballos on 05/10/2023.
//

import Foundation
import GoogleMobileAds
//import FirebaseCore

  /*class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        

      return true
    }
  }*/

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    //FirebaseApp.configure()
      //GADMobileAds.sharedInstance().start(completionHandler: nil)
      //FBAudienceNetworkAds.initialize(with: nil, completionHandler: nil)

          // Pass user's consent after acquiring it. For sample app purposes, this is set to YES.
     // FBAdSettings.setAdvertiserTrackingEnabled(true)
      let ads = GADMobileAds.sharedInstance()
         ads.start { status in
           // Optional: Log each adapter's initialization latency.
           let adapterStatuses = status.adapterStatusesByClassName
           for adapter in adapterStatuses {
             let adapterStatus = adapter.value
             NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
             adapterStatus.description, adapterStatus.latency)
           }

           // Start loading ads here...
         }

         return true
     // return true
  }
}
