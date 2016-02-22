//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Gregory White on 11/23/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

import FBSDKCoreKit

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {

	internal var window: UIWindow?

	internal func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
		return true
	}

	internal func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
	}

}

