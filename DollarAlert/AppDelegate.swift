//
//  AppDelegate.swift
//  DollarAlert
//
//  Created by Osvaldo Ceballos on 05/10/2023.
//

import Foundation
import GoogleMobileAds

  class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      print("Your code here")
      GADMobileAds.sharedInstance().start(completionHandler: nil)

      return true
    }
  }

