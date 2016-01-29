//
//  UdacityLoginViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

class UdacityLoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate { 

	// MARK: - Private Constants

	private struct Consts {
		static let UdacitySignupURLString = "https://www.udacity.com/account/auth#!/signup"
		static let UdacityLoginColor      = UIColor.orangeColor()
		static let FacebookLoginColor     = UIColor.blueColor()
		static let NoAlpha: CGFloat		 = 0.0
		static let ActivityAlpha: CGFloat = 0.7
	}

	private struct Alerts {
		struct Message {
			static let CheckLoginFields = "Check email & password fields"
		}

		struct Title {
			static let BadUserLoginData = "Login user data insufficient"
		}
	}

	// MARK: - Private Stored Variables

	private var isLoginViaUdacity = true
	private var dimmerView: UIView? = nil
	private var activityIndicator: UIActivityIndicatorView? = nil
	
	// MARK: - IB Outlets

	@IBOutlet weak var udacityLogo:       UIImageView!
	@IBOutlet weak var loginLabel:        UILabel!
	@IBOutlet weak var emailTextField:    UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton:		  UIButton!
	@IBOutlet weak var signUpButton:      UIButton!

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		addSubviews()
		addIndentationsToTextFields()
		createBackgroundColorGradient()

		loginLabel.textColor = UIColor.whiteColor()
		signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

		addNotificationObservers()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		struct Static {
			static var token: dispatch_once_t = 0
		}

		dispatch_once(&(Static.token), {
			self.addFacebookLoginButton()
			self.initActivityIndicator()
		});

	}

	// MARK: - IB Actions

	@IBAction func loginButtonDidTouchUpInside(sender: UIButton) {
		isLoginViaUdacity = true

		if emailTextField.text!.isEmpty    || emailTextField.text == "Email" ||
			passwordTextField.text!.isEmpty || passwordTextField.text == "Password"
		{
			self.presentAlert(Alerts.Title.BadUserLoginData, message: Alerts.Message.CheckLoginFields)
		} else {
			startActivityIndicator(Consts.UdacityLoginColor)
			UdacityAPIClient.sharedClient.loginViaUdacity(emailTextField.text! as String, password: passwordTextField.text! as String,
																										completionHandler: loginCompletionHandler)
		}

	}

	@IBAction func signUpButtonDidTouchUpInside(sender: UIButton) {
      openSystemBrowserWithURL(Consts.UdacitySignupURLString)
	}


	@IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {

		if isLoginViaUdacity {
			UdacityAPIClient.sharedClient.logout(logoutCompletionHandler)
		}

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

		stopActivityIndicator()

		if UdacityDataManager.sharedMgr.isLoginSuccessful {
			let navController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentLocsTabBarNavCtlr") as! UINavigationController
			self.presentViewController(navController, animated: true, completion: nil)
		}

	}

	// MARK: - FBSDKLoginButtonDelegate

	func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

		if let _ = error {
			self.presentAlert("Unable to authenticate via Facebook", message: error!.localizedDescription)
		} else if let accessToken = result.token {
			isLoginViaUdacity = false
			startActivityIndicator(Consts.FacebookLoginColor)
			UdacityAPIClient.sharedClient.loginViaFacebook(accessToken, completionHandler: loginViaFacebookCompletionHandler)
		}
	}

	func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
		UdacityAPIClient.sharedClient.logout(logoutCompletionHandler)
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
				self.stopActivityIndicator()
				self.presentAlert(Constants.Alert.Title.BadLogin, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.stopActivityIndicator()
				self.presentAlert(Constants.Alert.Title.BadLogin, message: Constants.Alert.Message.NoUserData)
				return
			}

			UdacityDataManager.sharedMgr.user = UdacityUser(userDict: result as! JSONDictionary)
		}

	}

	private var loginCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.stopActivityIndicator()
				self.presentAlert(Constants.Alert.Title.BadLogin, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.stopActivityIndicator()
				self.presentAlert(Constants.Alert.Title.BadLogin, message: Constants.Alert.Message.NoLoginResponseData)
				return
			}

			let JSONResult = result as! JSONDictionary

			let account = UdacityAccount(accountDict: JSONResult[UdacityAPIClient.API.AccountKey] as! JSONDictionary)
			let session = UdacitySession(sessionDict: JSONResult[UdacityAPIClient.API.SessionKey] as! JSONDictionary)

			UdacityDataManager.sharedMgr.loginData = (account, session)
		}

	}

	private var loginViaFacebookCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				print("\(error)")
				return
			}

			guard result != nil else {
				print("result is nil")
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

	// MARK: - Private UI Helpers

	private func addFacebookLoginButton() {
		let facebookLoginButton = FBSDKLoginButton(frame: emailTextField.frame)

		facebookLoginButton.frame.origin.y = view.frame.height - 20.0 - emailTextField.frame.height
		facebookLoginButton.delegate = self
		facebookLoginButton.hidden = false
		facebookLoginButton.enabled = true

		view.addSubview(facebookLoginButton)
	}

	private func addIndentationsToTextFields() {
		emailTextField.leftView        = UIView(frame: CGRectMake(0, 0, 10, self.emailTextField.frame.height))
		emailTextField.leftViewMode    = UITextFieldViewMode.Always
		passwordTextField.leftView     = UIView(frame: CGRectMake(0, 0, 10, self.passwordTextField.frame.height))
		passwordTextField.leftViewMode = UITextFieldViewMode.Always
	}

	private func addNotificationObservers() {
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

	private func addSubviews() {
		view.addSubview(udacityLogo)
		view.addSubview(loginLabel)
		view.addSubview(emailTextField)
		view.addSubview(passwordTextField)
		view.addSubview(loginButton)
		view.addSubview(signUpButton)
	}

	private func createBackgroundColorGradient() {
		view.backgroundColor = UIColor.whiteColor()

		let orange         = UIColor.orangeColor()
		let startingOrange = orange.colorWithAlphaComponent(0.5).CGColor as CGColorRef
		let endingOrange   = orange.colorWithAlphaComponent(1.0).CGColor as CGColorRef

		let gradientLayer       = CAGradientLayer()
		gradientLayer.frame     = view.bounds
		gradientLayer.colors    = [startingOrange, endingOrange]
		gradientLayer.locations = [0.0, 0.9]

		view.layer.addSublayer(gradientLayer)
	}

	private func initActivityIndicator() {
		dimmerView = UIView(frame: view.frame)
		dimmerView?.backgroundColor = UIColor.blackColor()
		dimmerView?.alpha           = Consts.NoAlpha

		view.addSubview(dimmerView!)
		view.bringSubviewToFront(dimmerView!)

		activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
		activityIndicator?.center    = dimmerView!.center
		activityIndicator?.center.y *= 1.5
		activityIndicator?.hidesWhenStopped = true

		dimmerView?.addSubview(activityIndicator!)
	}

	private func startActivityIndicator(color: UIColor)
	{
		dimmerView?.alpha = Consts.ActivityAlpha
		activityIndicator?.color  = color
		activityIndicator?.startAnimating()
	}

	private func stopActivityIndicator() {
		activityIndicator?.stopAnimating()
		dimmerView?.alpha = Consts.NoAlpha
	}

}
