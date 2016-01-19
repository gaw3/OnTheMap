//
//  StudentLocationsTabBarController.swift
//  OnTheMap
//
//  Created by Gregory White on 1/15/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

class StudentLocationsTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		ParseAPIClient.sharedClient.refreshStudentLocations(refreshStudentLocationsCompletionHandler)
	}

	// MARK: - IB Actions

	@IBAction func pinButtonWasTapped(sender: UIBarButtonItem) {
		ParseAPIClient.sharedClient.getStudentLocation(UdacityDataManager.sharedMgr.user!.userID!, completionHandler: getStudentLocationCompletionHandler)
	}

	@IBAction func refreshButtonWasTapped(sender: UIBarButtonItem) {
		ParseAPIClient.sharedClient.refreshStudentLocations(refreshStudentLocationsCompletionHandler)
	}

	var getStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.presentAlert(Constants.Alert.Title.BadGet, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Constants.Alert.Title.BadGet, message: Constants.Alert.Message.NoSL)
				return
			}

			let results    = (result as! JSONDictionary)[ParseAPIClient.API.ResultsKey] as? [JSONDictionary]
			let postInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier(StudentLocationsPostInformationViewController.UIConstants.StoryboardID)
								  as! StudentLocationsPostInformationViewController

//			postInfoVC.newStudent = (UdacityDataManager.sharedMgr.user!.firstName!,
//				UdacityDataManager.sharedMgr.user!.lastName!,
//				UdacityDataManager.sharedMgr.user!.userID!)
			if results!.isEmpty {
				postInfoVC.newStudent = (UdacityDataManager.sharedMgr.user!.firstName!,
												 UdacityDataManager.sharedMgr.user!.lastName!,
					                      UdacityDataManager.sharedMgr.user!.userID!)
			} else {
				postInfoVC.currentStudentLocation = StudentLocation(studentLocationDict: results!.first! as JSONDictionary)
			}

			self.presentViewController(postInfoVC, animated: true, completion: nil)
		}
		
	}
	
	private var refreshStudentLocationsCompletionHandler: APIDataTaskWithRequestCompletionHandler {

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
				newStudentLocations.append(StudentLocation(studentLocationDict: newStudentLocation))
			}

			StudentLocationsManager.sharedMgr.refreshStudentLocations(newStudentLocations)
		}
		
	}

}
