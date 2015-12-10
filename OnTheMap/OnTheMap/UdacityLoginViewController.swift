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

	// MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()
    }

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

	// MARK: - Navigation

	@IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
		UdacityAPIClient.sharedClient.logout(logoutCompletionHandler)
	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		assert(textField == emailTextField || textField == passwordTextField,
			"received notification from unexpected UITextField")

		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - Private Completion Handlers

	private var loginCompletionHandler : APIDataTaskWithRequestCompletionHandler {

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

			let JSONData = result as! Dictionary<String, AnyObject>

			if let session = JSONData[UdacityAPIClient.API.SessionKey] {

				if let _ = session[UdacityAPIClient.API.SessionIDKey] {
					let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentLocationsTabBarController")
												  as! UITabBarController
					self.presentViewController(tabBarController, animated: true, completion: nil)
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

	private var logoutCompletionHandler : APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				// handle error
				return
			}

			guard result != nil else {
				// handle error
				return
			}

			let JSONData = result as! Dictionary<String, AnyObject>

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
