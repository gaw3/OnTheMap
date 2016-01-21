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

	@IBAction func signUpButtonDidTouchUpInside(sender: UIButton) {
      openSystemBrowserWithURL(UdacitySignupURLString)
	}


	@IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
		UdacityAPIClient.sharedClient.logout(logoutCompletionHandler)
	}

	// MARK: - Private Constants

	private let UdacitySignupURLString = "https://www.udacity.com/account/auth#!/signup"
	
	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginResponseDataDidGetSaved:",
																					  name: Constants.Notification.LoginResponseDataDidGetSaved,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "logoutResponseDataDidGetSaved:",
																					  name: Constants.Notification.LogoutResponseDataDidGetSaved,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDataDidGetSaved:",
																					  name: Constants.Notification.UserDataDidGetSaved,
																					object: nil)
	}

	// MARK: - Notifications

	func loginResponseDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == Constants.Notification.LoginResponseDataDidGetSaved, "unknown notification = \(notification)")
		
		UdacityAPIClient.sharedClient.getUserData(UdacityDataManager.sharedMgr.account!.userID!,
																completionHandler: getUserDataCompletionHandler)
	}

	func logoutResponseDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == Constants.Notification.LogoutResponseDataDidGetSaved, "unknown notification = \(notification)")

		if UdacityDataManager.sharedMgr.isLogoutSuccessful {
			print("logged out successfully")
		}

	}

	func userDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == Constants.Notification.UserDataDidGetSaved, "unknown notification = \(notification)")

		if UdacityDataManager.sharedMgr.isLoginSuccessful {
			let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentLocsTabBarNavCtlr") as! UINavigationController
			self.presentViewController(tabBarController, animated: true, completion: nil)
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
				self.presentAlert(Constants.Alert.Title.BadLogin, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Constants.Alert.Title.BadLogin, message: Constants.Alert.Message.NoUserData)
				return
			}

			UdacityDataManager.sharedMgr.user = UdacityUser(userDict: result as! JSONDictionary)
		}

	}

	private var loginCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.presentAlert(Constants.Alert.Title.BadLogin, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Constants.Alert.Title.BadLogin, message: Constants.Alert.Message.NoLoginResponseData)
				return
			}

			let JSONResult = result as! JSONDictionary

			let account = UdacityAccount(accountDict: JSONResult[UdacityAPIClient.API.AccountKey] as! JSONDictionary)
			let session = UdacitySession(sessionDict: JSONResult[UdacityAPIClient.API.SessionKey] as! JSONDictionary)

			UdacityDataManager.sharedMgr.loginData = (account, session)
		}

	}

	private var logoutCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.presentAlert(Constants.Alert.Title.BadLogout, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Constants.Alert.Title.BadLogout, message: Constants.Alert.Message.NoLogoutResponseData)
				return
			}

			UdacityDataManager.sharedMgr.logoutData = UdacitySession(sessionDict: result as! JSONDictionary)
		}

	}

}
