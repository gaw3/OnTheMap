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
    
    fileprivate struct Alert {
        
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
    
    fileprivate struct PlaceholderText {
        static let Attributes    = [NSForegroundColorAttributeName: UIColor.white]
        static let EmailField    = "Email"
        static let InsetRect     = CGRect(x: 0, y: 0, width: 10, height: 50)
        static let PasswordField = "Password"
    }
    
    fileprivate struct URL {
        static let UdacitySignupURLString = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: - Private Stored Variables
    
    fileprivate var pleaseWaitView: PleaseWaitView? = nil
    
    // MARK: - Private Computed Variables
    
    fileprivate var udacityClient: UdacityAPIClient {
        return UdacityAPIClient.sharedClient
    }
    
    private lazy var foo: Void = {
        self.addFacebookLoginButton()
        self.initPleaseWaitView()
    }()
    
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
        
        _ = foo
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setTextFieldPlaceholders()
        createBackgroundColorGradient()
        
        loginLabel.textColor = UIColor.white
        signUpButton.setTitleColor(UIColor.white, for: UIControlState())
        
        addNotificationObservers()
    }
    
    // MARK: - IB Actions
    
    @IBAction internal func loginButtonDidTouchUpInside(_ sender: UIButton) {
        assert(sender == loginButton, "rcvd IB Action from unknown button")
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.presentAlert(Alert.Title.BadUserLoginData, message: Alert.Message.CheckLoginFields)
        } else {
            pleaseWaitView?.startActivityIndicator()
            udacityClient.loginWithUdacityUser(emailTextField.text! as String, password: passwordTextField.text! as String,
                                               completionHandler: loginCompletionHandler)
        }
        
    }
    
    @IBAction internal func signUpButtonDidTouchUpInside(_ sender: UIButton) {
        assert(sender == signUpButton, "rcvd IB Action from unknown button")
        openSystemBrowserWithURL(URL.UdacitySignupURLString)
    }
    
    @IBAction func unwindToLoginViewController(_ segue: UIStoryboardSegue) {
        emailTextField.text    = ""
        passwordTextField.text = ""
        
        logoutFromFacebook()
        udacityClient.logout(logoutCompletionHandler)
    }
    
    // MARK: - FBSDKLoginButtonDelegate
    
    internal func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let _ = error {
            self.presentAlert(Alert.Title.BadFBAuth, message: error!.localizedDescription)
        } else if let facebookAccessToken = result.token {
            pleaseWaitView?.startActivityIndicator()
            udacityClient.loginWithFacebookAuthorization(facebookAccessToken, completionHandler: loginCompletionHandler)
        }
        
    }
    
    internal func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // must have this to satisfy the protocol
    }
    
    // MARK: - UITextFieldDelegate
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        assert(textField == emailTextField || textField == passwordTextField, "unknown UITextField = \(textField)")
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Private:  Completion Handlers as Computed Variables
    
    fileprivate var getUserProfileDataCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
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
    
    fileprivate var loginCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
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
    
    fileprivate var logoutCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
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
    
    fileprivate func addFacebookLoginButton() {
        let facebookLoginButton = FBSDKLoginButton(frame: emailTextField.frame)
        
        facebookLoginButton.frame.origin.y = view.frame.height - 20.0 - emailTextField.frame.height
        facebookLoginButton.delegate = self
        facebookLoginButton.isHidden   = false
        facebookLoginButton.isEnabled  = true
        
        view.addSubview(facebookLoginButton)
    }
    
    fileprivate func addSubviews() {
        view.addSubview(udacityLogo)
        view.addSubview(loginLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
    }
    
    fileprivate func cleanup(_ alertTitle: String, alertMessage: String) {
        logoutFromFacebook()
        pleaseWaitView?.stopActivityIndicator()
        presentAlert(alertTitle, message: alertMessage)
    }
    
    fileprivate func createBackgroundColorGradient() {
        view.backgroundColor = UIColor.white
        
        let orange         = UIColor.orange
        let startingOrange = orange.withAlphaComponent(0.5).cgColor as CGColor
        let endingOrange   = orange.withAlphaComponent(1.0).cgColor as CGColor
        
        let gradientLayer       = CAGradientLayer()
        gradientLayer.frame     = view.bounds
        gradientLayer.colors    = [startingOrange, endingOrange]
        gradientLayer.locations = [0.0, 0.9]
        
        view.layer.addSublayer(gradientLayer)
    }
    
    fileprivate func logoutFromFacebook() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    fileprivate func initPleaseWaitView() {
        pleaseWaitView = PleaseWaitView(requestingView: view)
        view.addSubview(pleaseWaitView!.dimmedView)
        view.bringSubview(toFront: pleaseWaitView!.dimmedView)
    }
    
    fileprivate func setTextFieldPlaceholders() {
        emailTextField.leftView                 = UIView(frame: PlaceholderText.InsetRect)
        emailTextField.leftViewMode             = .always
        emailTextField.attributedPlaceholder    = NSAttributedString(string: PlaceholderText.EmailField, attributes: PlaceholderText.Attributes)
        
        passwordTextField.leftView              = UIView(frame: PlaceholderText.InsetRect)
        passwordTextField.leftViewMode          = .always
        passwordTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.PasswordField, attributes: PlaceholderText.Attributes)
    }
    
}

// MARK: - Notifications

extension UdacityLoginViewController {
    
    func processNotification(_ notification: Notification) {
        
        switch notification.name {
            
        case NotificationName.UdacityLoginResponseDataDidGetSaved:
            udacityClient.getUserProfileData(udacityDataMgr.account!.userID!, completionHandler: getUserProfileDataCompletionHandler)
            
        case NotificationName.UdacityLogoutResponseDataDidGetSaved: break
            
        case NotificationName.UdacityUserDataDidGetSaved:
            pleaseWaitView?.stopActivityIndicator()
            
            if udacityDataMgr.isLoginSuccessful {
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "StudentLocsTabBarNavCtlr") as! UINavigationController
                self.present(navController, animated: true, completion: nil)
            }
            
            
        default: fatalError("Received unknown notification = \(notification)")
        }
        
    }
    
}
private extension UdacityLoginViewController {
    
    struct SEL {
        static let ProcessNotification = #selector(processNotification(_:))
    }
    
    func addNotificationObservers() {
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.UdacityLoginResponseDataDidGetSaved,  object: nil)
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.UdacityLogoutResponseDataDidGetSaved, object: nil)
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.UdacityUserDataDidGetSaved,           object: nil)
    }
    
}



