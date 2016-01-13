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

	func presentAlert(title: String, message: String) {
		let alert  = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: Constants.Alert.ActionTitle.OK, style: .Default, handler: nil)
		alert.addAction(action)

		dispatch_async(dispatch_get_main_queue(), {
			self.presentViewController(alert, animated: true, completion: nil)
		})

	}

	var refreshStudentLocationsCompletionHandler : APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.presentAlert(Constants.Alert.Title.BadRefresh, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Constants.Alert.Title.BadRefresh, message: Constants.Alert.Message.NoSLArray)
				return
			}

			let results = (result as! JSONDictionary)[ParseAPIClient.API.ResultsKey] as! [JSONDictionary]?

			guard !(results!.isEmpty) else {
				self.presentAlert(Constants.Alert.Title.BadRefresh, message: Constants.Alert.Message.EmptySLArray)
				return
			}

			var newStudentLocations = [StudentLocation]()

			for newStudentLocation: JSONDictionary in results! {
				newStudentLocations.append(StudentLocation(studentLocation: newStudentLocation))
			}

			StudentLocationsManager.sharedMgr.refreshStudentLocations(newStudentLocations)
		}
		
	}
	
}