//
//  UdacityLoginViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

final internal class UdacityLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

	// MARK: - Private Constants

	private struct SEL {
		static let LoginResponseDataDidGetSaved  = #selector(loginResponseDataDidGetSaved(_:))
		static let LogoutResponseDataDidGetSaved = #selector(logoutResponseDataDidGetSaved(_:))
		static let UserDataDidGetSaved           = #selector(userDataDidGetSaved(_:))
	}

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

	private struct PlaceholderText {
		static let Attributes    = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		static let EmailField    = "Email"
		static let InsetRect     = CGRectMake(0, 0, 10, 50)
		static let PasswordField = "Password"
	}

	private struct URL {
		static let UdacitySignupURLString = "https://www.udacity.com/account/auth#!/signup"
	}

	// MARK: - Private Stored Variables

	private var pleaseWaitView: PleaseWaitView? = nil

	// MARK: - Private Computed Variables

	private var udacityClient: UdacityAPIClient {
		return UdacityAPIClient.sharedClient
	}

	// MARK: - IB Outlets

	@IBOutlet weak internal var udacityLogo:       UIImageView!
	@IBOutlet weak internal var loginLabel:        UILabel!
	@IBOutlet weak internal var emailTextField:    UITextField!
	@IBOutlet weak internal var passwordTextField: UITextField!
	@IBOutlet weak internal var loginButton:		  UIButton!
	@IBOutlet weak internal var signUpButton:      UIButton!

	// MARK: - View Events

	override internal func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		struct DispatchOnce {
			static var token: dispatch_once_t = 0
		}

		dispatch_once(&(DispatchOnce.token), {
			self.addFacebookLoginButton()
			self.initPleaseWaitView()
		});

	}

	override internal func viewDidLoad() {
		super.viewDidLoad()

		addSubviews()
		setTextFieldPlaceholders()
		createBackgroundColorGradient()

		loginLabel.textColor = UIColor.whiteColor()
		signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

		addNotificationObservers()
	}
	
	// MARK: - IB Actions

	@IBAction internal func loginButtonDidTouchUpInside(sender: UIButton) {
		assert(sender == loginButton, "rcvd IB Action from unknown button")

		if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
			self.presentAlert(Alert.Title.BadUserLoginData, message: Alert.Message.CheckLoginFields)
		} else {
			pleaseWaitView?.startActivityIndicator()
			udacityClient.loginWithUdacityUser(emailTextField.text! as String, password: passwordTextField.text! as String,
																						 completionHandler: loginCompletionHandler)
		}

	}

	@IBAction internal func signUpButtonDidTouchUpInside(sender: UIButton) {
		assert(sender == signUpButton, "rcvd IB Action from unknown button")
      openSystemBrowserWithURL(URL.UdacitySignupURLString)
	}

	@IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
		emailTextField.text    = ""
		passwordTextField.text = ""

		logoutFromFacebook()
		udacityClient.logout(logoutCompletionHandler)
	}

	// MARK: - Notifications

	internal func loginResponseDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == UdacityDataManager.Notification.LoginResponseDataDidGetSaved, "unknown notification = \(notification)")
		
		udacityClient.getUserProfileData(udacityDataMgr.account!.userID!,
													completionHandler: getUserProfileDataCompletionHandler)
	}

	internal func logoutResponseDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == UdacityDataManager.Notification.LogoutResponseDataDidGetSaved, "unknown notification = \(notification)")

		// leave here in case there is ever anything to do
	}

	internal func userDataDidGetSaved(notification: NSNotification) {
		assert(notification.name == UdacityDataManager.Notification.UserDataDidGetSaved, "unknown notification = \(notification)")

		pleaseWaitView?.stopActivityIndicator()

		if udacityDataMgr.isLoginSuccessful {
			let navController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentLocsTabBarNavCtlr") as! UINavigationController
			self.presentViewController(navController, animated: true, completion: nil)
		}

	}

	// MARK: - FBSDKLoginButtonDelegate

	internal func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

		if let _ = error {
			self.presentAlert(Alert.Title.BadFBAuth, message: error!.localizedDescription)
		} else if let facebookAccessToken = result.token {
			pleaseWaitView?.startActivityIndicator()
			udacityClient.loginWithFacebookAuthorization(facebookAccessToken, completionHandler: loginCompletionHandler)
		}
		
	}

	internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
		// must have this to satisfy the protocol
	}

	// MARK: - UITextFieldDelegate

	internal func textFieldShouldReturn(textField: UITextField) -> Bool {
		assert(textField == emailTextField || textField == passwordTextField, "unknown UITextField = \(textField)")

		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - Private:  Completion Handlers as Computed Variables

	private var getUserProfileDataCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.cleanup(Alert.Title.BadUserProfileData, alertMessage: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.cleanup(Alert.Title.BadUserProfileData, alertMessage: Alert.Message.NoJSONData)
				return
			}

			self.udacityDataMgr.user = UdacityUser(userDict: result as! JSONDictionary)
		}

	}

	private var loginCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.cleanup(Alert.Title.BadLogin, alertMessage: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.cleanup(Alert.Title.BadLogin, alertMessage: Alert.Message.NoJSONData)
				return
			}

			let JSONResult = result as! JSONDictionary

			let account = UdacityAccount(accountDict: JSONResult[UdacityAPIClient.API.AccountKey] as! JSONDictionary)
			let session = UdacitySession(sessionDict: JSONResult[UdacityAPIClient.API.SessionKey] as! JSONDictionary)

			self.udacityDataMgr.loginData = (account, session)
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

			self.udacityDataMgr.logoutData = UdacitySession(sessionDict: result as! JSONDictionary)
		}

	}

	// MARK: - Private UI Helpers

	private func addFacebookLoginButton() {
		let facebookLoginButton = FBSDKLoginButton(frame: emailTextField.frame)

		facebookLoginButton.frame.origin.y = view.frame.height - 20.0 - emailTextField.frame.height
		facebookLoginButton.delegate = self
		facebookLoginButton.hidden   = false
		facebookLoginButton.enabled  = true

		view.addSubview(facebookLoginButton)
	}

	private func addNotificationObservers() {
		notifCtr.addObserver(self, selector: SEL.LoginResponseDataDidGetSaved,
												 name: UdacityDataManager.Notification.LoginResponseDataDidGetSaved,
											  object: nil)
		notifCtr.addObserver(self, selector: SEL.LogoutResponseDataDidGetSaved,
											    name: UdacityDataManager.Notification.LogoutResponseDataDidGetSaved,
											  object: nil)
		notifCtr.addObserver(self, selector: SEL.UserDataDidGetSaved,
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

	private func cleanup(alertTitle: String, alertMessage: String) {
		logoutFromFacebook()
		pleaseWaitView?.stopActivityIndicator()
		presentAlert(alertTitle, message: alertMessage)
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

	private func logoutFromFacebook() {
		let loginManager = FBSDKLoginManager()
		loginManager.logOut()
	}

	private func initPleaseWaitView() {
		pleaseWaitView = PleaseWaitView(requestingView: view)
		view.addSubview(pleaseWaitView!.dimmedView)
		view.bringSubviewToFront(pleaseWaitView!.dimmedView)
	}

	private func setTextFieldPlaceholders() {
		emailTextField.leftView                 = UIView(frame: PlaceholderText.InsetRect)
		emailTextField.leftViewMode             = .Always
		emailTextField.attributedPlaceholder    = NSAttributedString(string: PlaceholderText.EmailField, attributes: PlaceholderText.Attributes)

		passwordTextField.leftView              = UIView(frame: PlaceholderText.InsetRect)
		passwordTextField.leftViewMode          = .Always
		passwordTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.PasswordField, attributes: PlaceholderText.Attributes)
	}
	
}
