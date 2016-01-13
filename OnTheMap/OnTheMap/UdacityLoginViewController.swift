//
//  UdacityLoginViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class UdacityLoginViewController: UIViewController, UITextFieldDelegate {

	// MARK: - IB Outlets

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

   // MARK: - IB Actions

	@IBAction func loginButtonDidTouchUpInside(sender: UIButton) {

		UdacityAPIClient.sharedClient.login("gwhite2003@verizon.net", password: "chopper",
			completionHandler: loginCompletionHandler)

//		guard emailTextField.text != "" else {
//			// button is made inactive
//			// alert action view or whatever to notifiy of empty field
//			return
//		}
//
//		guard passwordTextField.text != "" else {
//			// button is made inactive
//			// alert action view or whatever to notifiy of empty field
//			return
//		}
//
//		UdacityAPIClient.sharedClient.login(emailTextField.text! as String, password: passwordTextField.text! as String,
//														completionHandler: loginCompletionHandler)
	}

	@IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
		UdacityAPIClient.sharedClient.logout(logoutCompletionHandler)
	}

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginResponseDataDidGetSaved:",
																					  name: Constants.Notification.LoginResponseDataDidGetSaved,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDataDidGetSaved:",
																					  name: Constants.Notification.UserDataDidGetSaved,
																					object: nil)
	}

	// MARK: - NSNotifications

	func loginResponseDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == Constants.Notification.LoginResponseDataDidGetSaved, "unknown notification = \(notification)")
		
		UdacityAPIClient.sharedClient.getUserData(UdacityUserManager.sharedMgr.accountUserID!,
																completionHandler: getUserDataCompletionHandler)
	}

	func userDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == Constants.Notification.UserDataDidGetSaved, "unknown notification = \(notification)")

		if UdacityUserManager.sharedMgr.isLoginSuccessful {
			let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier(Constants.UI.StoryboardID.StudentLocationsTabBarController) as! UITabBarController
			self.presentViewController(tabBarController, animated: true, completion: nil)
		} else {
			// alert action view
		}

	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		assert(textField == emailTextField || textField == passwordTextField, "unknown UITextField = \(textField)")

		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - Private:  Completion Handlers as Computed Variables

	private var getUserDataCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.presentAlert(Constants.Alert.Title.BadUserData, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Constants.Alert.Title.BadUserData, message: Constants.Alert.Message.NoUserData)
				return
			}

			let userData = UdacityUserData(data: result as! JSONDictionary)

			guard userData.isValid else {
				self.presentAlert(Constants.Alert.Title.BadUserData, message: Constants.Alert.Message.BadUserData)
				return
			}

			UdacityUserManager.sharedMgr.setUserData(userData)
		}

	}

	private var loginCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.presentAlert(Constants.Alert.Title.BadLoginResponseData, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Constants.Alert.Title.BadLoginResponseData, message: Constants.Alert.Message.NoLoginResponseData)
				return
			}

			let loginResponseData = UdacityLoginResponseData(data: result as! JSONDictionary)

			guard loginResponseData.isValid else {
				self.presentAlert(Constants.Alert.Title.BadLoginResponseData, message: Constants.Alert.Message.BadLoginResponseData)
				return
			}

			UdacityUserManager.sharedMgr.setLoginResponseData(loginResponseData)
		}

	}

	private var logoutCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				// handle error
				return
			}

			guard result != nil else {
				// handle error
				return
			}

			let JSONData = result as! JSONDictionary

			if let session = JSONData[UdacityAPIClient.API.SessionKey] {

				if let _ = session[UdacityAPIClient.API.SessionIDKey] {
				} else {
					print("no session ID")
					// alert action view again
				}

			} else {
				print("no session")
				// alert action view again
			}

		}

	}

}
