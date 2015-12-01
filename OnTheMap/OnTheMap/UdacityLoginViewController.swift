//
//  UdacityLoginViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class UdacityLoginViewController: UIViewController {

	// MARK: - IB Outlets

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	// MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()
    }

   // MARK: - IB Actions

	@IBAction func loginButtonTouchUpInside(sender: UIButton) {
		UdacityAPIClient.loginWithUsername("gwhite2003@verizon.net", password: "chopper", completionHandler: completeLogin)
		// 1. verify textfields have something in them
		// 2. use udacity client to login
		// 2.5 if logged in, move to main tabbar controller
		// 3. provide error indicators to user
	}

	@IBAction func logoutButtonTouchUpInside(sender: UIButton) {
		UdacityAPIClient.logout(completeLogout)
		// 1. verify textfields have something in them
		// 2. use udacity client to login
		// 2.5 if logged in, move to main tabbar controller
		// 3. provide error indicators to user
	}


	@IBAction func getStudentLocationsButtonDidTouchUpInside(sender: UIButton) {
		ParseAPIClient.getStudentLocations(completeGetStudentLocations)
	}

	@IBAction func postStudentLocationButtonDidTouchUp(sender: UIButton) {
		ParseAPIClient.postStudentLocation(completePostStudentLocation)
	}
	
	func completeGetStudentLocations(result: AnyObject!, error: NSError?) {

		guard error == nil else {
			// handle error
			return
		}

		guard result != nil else {
			// handle error
			return
		}

		let json = result as! Dictionary<String, AnyObject>

		if let studentLocations = json["results"] {
			print("student locations json = \(studentLocations)")
		}

	}

	func completePostStudentLocation(result: AnyObject!, error: NSError?) {

		guard error == nil else {
			// handle error
			return
		}

		guard result != nil else {
			// handle error
			return
		}

		let json = result as! Dictionary<String, AnyObject>
		print("post student location json = \(json)")
	}
	
	func completeLogin(result: AnyObject!, error: NSError?) {

		guard error == nil else {
			// handle error
			return
		}

		guard result != nil else {
			// handle error
			return
		}

		let json = result as! Dictionary<String, AnyObject>
		print("login json = \(json)")

		if let jsonSession = json["session"] {

			if let jsonSessionID = jsonSession["id"] {
				// save session ID?
				// save logged in state?
				// segue to tabbar controller
			} else {
				// handle error
			}

		} else {
			//handle error
		}

	}

	func completeLogout(result: AnyObject!, error: NSError?) {

		guard error == nil else {
			// handle error
			return
		}

		guard result != nil else {
			// handle error
			return
		}

		let json = result as! Dictionary<String, AnyObject>
		print("logout json = \(json)")

		if let jsonSession = json["session"] {

			if let jsonSessionID = jsonSession["id"] {
				// save session ID?
				// save logged in state?
				// segue to tabbar controller
			} else {
				// handle error
			}

		} else {
			//handle error
		}
		
	}

}
