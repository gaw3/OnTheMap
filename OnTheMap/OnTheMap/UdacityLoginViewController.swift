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

		guard emailTextField.text != "" else {
			// button is made inactive
			// alert action view or whatever to notifiy of empty field
			return
		}

		guard passwordTextField.text != "" else {
			// button is made inactive
			// alert action view or whatever to notifiy of empty field
			return
		}

		UdacityAPIClient.sharedClient.login(emailTextField.text! as String, password: passwordTextField.text! as String,
														completionHandler: loginCompletionHandler)
	}

	@IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
		UdacityAPIClient.sharedClient.logout(logoutCompletionHandler)
	}

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "accountDataDidGetSaved:",
			name: LoginResponseDataDidGetSavedNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDataDidGetSaved:",
			name: UserDataDidGetSavedNotification, object: nil)
	}

	// MARK: - NSNotifications

	func accountDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == LoginResponseDataDidGetSavedNotification, "unknown notification = \(notification)")
		
		UdacityAPIClient.sharedClient.getUserData(UdacityUserManager.sharedMgr.accountUserID!,
																completionHandler: getUserDataCompletionHandler)
	}

	func userDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == UserDataDidGetSavedNotification, "unknown notification = \(notification)")

		if UdacityUserManager.sharedMgr.isLoginSuccessful {
			let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentLocationsTabBarController") as! UITabBarController
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
	
	// MARK: - Completion Handlers written as
	// MARK: Private Computed Variables

	private var getUserDataCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				print("error = \(error)")
				// alert action view to the user that error occurred
				return
			}

			guard result != nil else {
				print("no json data provided to login completion handler")
				// alert action view again
				return
			}

			let userData = UdacityUserData(data: result as! JSONDictionary)

			if userData.isValid {
				UdacityUserManager.sharedMgr.setUserData(userData)
				return
			}

			// alert action view if needed
		}

	}

	private var loginCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				print("error = \(error)")
				// alert action view to the user that error occurred
				return
			}

			guard result != nil else {
				print("no json data provided to login completion handler")
				// alert action view again
				return
			}

			let loginResponseData = UdacityLoginResponseData(data: result as! JSONDictionary)

			if loginResponseData.isValid {
				UdacityUserManager.sharedMgr.setLoginResponseData(loginResponseData)
				return
			}

			// alert action view if needed
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
