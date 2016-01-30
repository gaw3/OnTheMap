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

	private struct Alert {

		struct Message {
			static let CheckLoginFields = "Check email & password fields"
			static let NoJSONData       = "JSON data unavailable"
		}

		struct Title {
			static let BadFBAuth          = "Facebook authentication failed"
			static let BadLogin           = "Unable to login"
			static let BadLogout          = "Unable to logout"
			static let BadUserLoginData   = "Login user data insufficient"
			static let BadUserProfileData = "Unable to retrieve user profile"
		}

	}

	private struct URL {
		static let UdacitySignupURLString = "https://www.udacity.com/account/auth#!/signup"
	}

	// MARK: - Private Stored Variables

	private var pleaseWaitView: PleaseWaitView? = nil
	private var isLoggedOut = true

	// MARK: - IB Outlets

	@IBOutlet weak var udacityLogo:       UIImageView!
	@IBOutlet weak var loginLabel:        UILabel!
	@IBOutlet weak var emailTextField:    UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton:		  UIButton!
	@IBOutlet weak var signUpButton:      UIButton!

	// MARK: - View Events

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		struct DispatchOnce {
			static var token: dispatch_once_t = 0
		}

		dispatch_once(&(DispatchOnce.token), {
			self.addFacebookLoginButton()
			self.initPleaseWaitView()
		});

	}

	override func viewDidLoad() {
		super.viewDidLoad()

		addSubviews()
		addIndentationsToTextFields()
		createBackgroundColorGradient()

		loginLabel.textColor = UIColor.whiteColor()
		signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

		addNotificationObservers()
	}
	
	// MARK: - IB Actions

	@IBAction func loginButtonDidTouchUpInside(sender: UIButton) {
		assert(sender == loginButton, "rcvd IB Action from unknown button")

		if emailTextField.text!.isEmpty    || emailTextField.text == "Email" ||
			passwordTextField.text!.isEmpty || passwordTextField.text == "Password" {
			self.presentAlert(Alert.Title.BadUserLoginData, message: Alert.Message.CheckLoginFields)
		} else {
			pleaseWaitView?.startActivityIndicator()
			UdacityAPIClient.sharedClient.loginWithUdacityUser(emailTextField.text! as String, password: passwordTextField.text! as String,
																										     completionHandler: loginCompletionHandler)
		}

	}

	@IBAction func signUpButtonDidTouchUpInside(sender: UIButton) {
		assert(sender == signUpButton, "rcvd IB Action from unknown button")
      openSystemBrowserWithURL(URL.UdacitySignupURLString)
	}

	@IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {

		if !isLoggedOut {
			UdacityAPIClient.sharedClient.logout(logoutCompletionHandler)
		}

	}

	// MARK: - Notifications

	func loginResponseDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == UdacityDataManager.Notification.LoginResponseDataDidGetSaved, "unknown notification = \(notification)")
		
		UdacityAPIClient.sharedClient.getUserProfileData(UdacityDataManager.sharedMgr.account!.userID!,
																       completionHandler: getUserProfileDataCompletionHandler)
	}

	func logoutResponseDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == UdacityDataManager.Notification.LogoutResponseDataDidGetSaved, "unknown notification = \(notification)")

		if UdacityDataManager.sharedMgr.isLogoutSuccessful {
			isLoggedOut = true
		}

	}

	func userDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == UdacityDataManager.Notification.UserDataDidGetSaved, "unknown notification = \(notification)")

		pleaseWaitView?.stopActivityIndicator()

		if UdacityDataManager.sharedMgr.isLoginSuccessful {
			isLoggedOut = false
			let navController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentLocsTabBarNavCtlr") as! UINavigationController
			self.presentViewController(navController, animated: true, completion: nil)
		}

	}

	// MARK: - FBSDKLoginButtonDelegate

	func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

		if let _ = error {
			self.presentAlert(Alert.Title.BadFBAuth, message: error!.localizedDescription)
		} else if let facebookAccessToken = result.token {
			pleaseWaitView?.startActivityIndicator()
			UdacityAPIClient.sharedClient.loginWithFacebookAuthorization(facebookAccessToken, completionHandler: loginCompletionHandler)
		}
		
	}

	func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {

		if !isLoggedOut {
			UdacityAPIClient.sharedClient.logout(logoutCompletionHandler)
		}

	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		assert(textField == emailTextField || textField == passwordTextField, "unknown UITextField = \(textField)")

		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - Private:  Completion Handlers as Computed Variables

	private var getUserProfileDataCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.pleaseWaitView?.stopActivityIndicator()
				self.presentAlert(Alert.Title.BadUserProfileData, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.pleaseWaitView?.stopActivityIndicator()
				self.presentAlert(Alert.Title.BadUserProfileData, message: Alert.Message.NoJSONData)
				return
			}

			UdacityDataManager.sharedMgr.user = UdacityUser(userDict: result as! JSONDictionary)
		}

	}

	private var loginCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.pleaseWaitView?.stopActivityIndicator()
				self.presentAlert(Alert.Title.BadLogin, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.pleaseWaitView?.stopActivityIndicator()
				self.presentAlert(Alert.Title.BadLogin, message: Alert.Message.NoJSONData)
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
				self.presentAlert(Alert.Title.BadLogout, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Alert.Title.BadLogout, message: Alert.Message.NoJSONData)
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
																					  name: UdacityDataManager.Notification.LoginResponseDataDidGetSaved,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "logoutResponseDataDidGetSaved:",
																				     name: UdacityDataManager.Notification.LogoutResponseDataDidGetSaved,
																				   object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDataDidGetSaved:",
																				     name: UdacityDataManager.Notification.UserDataDidGetSaved,
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

	private func initPleaseWaitView() {
		pleaseWaitView = PleaseWaitView(requestingView: view)
		view.addSubview(pleaseWaitView!.dimmedView)
		view.bringSubviewToFront(pleaseWaitView!.dimmedView)
	}

}
