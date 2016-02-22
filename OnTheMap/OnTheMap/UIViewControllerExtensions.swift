//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

extension UIViewController {

	// MARK: - Private Constants

	private struct Alert {
		static let ActionTitle = "OK"
		static let Message     = "Malformed URL"
		static let Title       = "Unable to open browser"
	}

	// MARK: - Internal Computed Variables

	internal var notifCtr: NSNotificationCenter{
		return NSNotificationCenter.defaultCenter()
	}

	internal var parseClient: ParseAPIClient {
		return ParseAPIClient.sharedClient
	}

	internal var slMgr: StudentLocationsManager {
		return StudentLocationsManager.sharedMgr
	}

	internal var udacityDataMgr: UdacityDataManager {
		return UdacityDataManager.sharedMgr
	}

	// MARK: - API

   internal func openSystemBrowserWithURL(URLString: String) {
      var success = false

		if let URLComponents = NSURLComponents(string: URLString) {
			if UIApplication.sharedApplication().openURL(URLComponents.URL!) { success = true }
		}

		if !success {
			presentAlert(Alert.Title, message: Alert.Message)
		}
	}

	internal func presentAlert(title: String, message: String) {
		let alert  = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: Alert.ActionTitle, style: .Default, handler: nil)
		alert.addAction(action)

		dispatch_async(dispatch_get_main_queue(), {
			self.presentViewController(alert, animated: true, completion: nil)
		})

	}


}