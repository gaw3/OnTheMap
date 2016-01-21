//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

extension (UIViewController) {

	// MARK: - API

   func openSystemBrowserWithURL(URLString: String) {
      var success = false

		if let URLComponents = NSURLComponents(string: URLString) {
			if UIApplication.sharedApplication().openURL(URLComponents.URL!) { success = true }
		}

		if !success {
			presentAlert(Constants.Alert.Title.BadBrowser, message: Constants.Alert.Message.BadURL)
		}
	}

	func presentAlert(title: String, message: String) {
		let alert  = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: Constants.Alert.ActionTitle.OK, style: .Default, handler: nil)
		alert.addAction(action)

		dispatch_async(dispatch_get_main_queue(), {
			self.presentViewController(alert, animated: true, completion: nil)
		})

	}

}