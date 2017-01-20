//
//  UdacityLoginViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

final class UdacityLoginViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak  var udacityLogo:       UIImageView!
    @IBOutlet weak  var loginLabel:        UILabel!
    @IBOutlet weak  var emailTextField:    UITextField!
    @IBOutlet weak  var passwordTextField: UITextField!
    @IBOutlet weak  var loginButton:	   UIButton!
    @IBOutlet weak  var signUpButton:      UIButton!
    
    // MARK: - IB Actions
    
    @IBAction func loginButtonDidTouchUpInside(_ sender: UIButton) {
        assert(sender == loginButton, "rcvd IB Action from unknown button")
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.presentAlert(Alert.Title.BadUserLoginData, message: Alert.Message.CheckLoginFields)
        } else {
            pleaseWaitView?.startActivityIndicator()
            UdacityAPIClient.shared.loginWithUdacityUser(emailTextField.text! as String, password: passwordTextField.text! as String, completionHandler: loginCompletionHandler)
        }
        
    }
    
    @IBAction func signUpButtonDidTouchUpInside(_ sender: UIButton) {
        assert(sender == signUpButton, "rcvd IB Action from unknown button")
        openSystemBrowserWithURL(URL.UdacitySignupURLString)
    }
    
    @IBAction func unwindToLoginViewController(_ segue: UIStoryboardSegue) {
        emailTextField.text    = ""
        passwordTextField.text = ""
        
        logoutFromFacebook()
        UdacityAPIClient.shared.logout(logoutCompletionHandler)
    }
    
    // MARK: - Variables
    
    fileprivate var pleaseWaitView: PleaseWaitView? = nil
    
    private lazy var foo: Void = {
        self.addFacebookLoginButton()
        self.initPleaseWaitView()
    }()
    
    // MARK: - View Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _ = foo
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setTextFieldPlaceholders()
        createBackgroundColorGradient()
        
        loginLabel.textColor = UIColor.white
        signUpButton.setTitleColor(UIColor.white, for: UIControlState())
        
        addNotificationObservers()
    }
    
}



// MARK: -
// MARK: - Notifications

extension UdacityLoginViewController {
    
    func processNotification(_ notification: Notification) {
        
        switch notification.name {
            
        case Notifications.UdacityLoginResponseDataDidGetSaved:
            UdacityAPIClient.shared.getUserProfileData(UdacityDataManager.shared.account!.userID, completionHandler: getUserProfileDataCompletionHandler)
            
        case Notifications.UdacityLogoutResponseDataDidGetSaved: break
            
        case Notifications.UdacityUserDataDidGetSaved:
            pleaseWaitView?.stopActivityIndicator()
            
            if UdacityDataManager.shared.isLoginSuccessful {
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "StudentLocsTabBarNavCtlr") as! UINavigationController
                self.present(navController, animated: true, completion: nil)
            }
            
            
        default: fatalError("Received unknown notification = \(notification)")
        }
        
    }
    
}



// MARK: - Facebook SDK Login Button Delegate

extension UdacityLoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let _ = error {
            self.presentAlert(Alert.Title.BadFBAuth, message: error!.localizedDescription)
        } else if let facebookAccessToken = result.token {
            pleaseWaitView?.startActivityIndicator()
            UdacityAPIClient.shared.loginWithFacebookAuthorization(facebookAccessToken, completionHandler: loginCompletionHandler)
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // must have this to satisfy the protocol
    }
    
}



// MARK: - Text Field Delegate

extension UdacityLoginViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        assert(textField == emailTextField || textField == passwordTextField, "unknown UITextField = \(textField)")
        
        textField.resignFirstResponder()
        return true
    }
    
}



// MARK: - Private Completion Handlers

private extension UdacityLoginViewController {
    
    var getUserProfileDataCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }

            guard error == nil else {
                strongSelf.cleanup(Alert.Title.BadUserProfileData, alertMessage: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                strongSelf.cleanup(Alert.Title.BadUserProfileData, alertMessage: Alert.Message.NoJSONData)
                return
            }
            
            UdacityDataManager.shared.user = UdacityUser(userDict: result as! JSONDictionary)
        }
        
    }
    
    var loginCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                strongSelf.cleanup(Alert.Title.BadLogin, alertMessage: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                strongSelf.cleanup(Alert.Title.BadLogin, alertMessage: Alert.Message.NoJSONData)
                return
            }
            
            let JSONResult = result as! JSONDictionary
            
            let account = UdacityAccount(accountDict: JSONResult[UdacityAPIClient.API.AccountKey] as! JSONDictionary)
            let session = UdacitySession(sessionDict: JSONResult[UdacityAPIClient.API.SessionKey] as! JSONDictionary)
            
            UdacityDataManager.shared.loginData = (account, session)
        }
        
    }
    
    var logoutCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                strongSelf.presentAlert(Alert.Title.BadLogout, message: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                strongSelf.presentAlert(Alert.Title.BadLogout, message: Alert.Message.NoJSONData)
                return
            }
            
            UdacityDataManager.shared.logoutData = UdacitySession(sessionDict: result as! JSONDictionary)
        }
        
    }
    
}



// MARK: - Private Helpers

private extension UdacityLoginViewController {
    
    struct PlaceholderText {
        static let Attributes    = [NSForegroundColorAttributeName: UIColor.white]
        static let EmailField    = "Email"
        static let InsetRect     = CGRect(x: 0, y: 0, width: 10, height: 50)
        static let PasswordField = "Password"
    }
    
    struct SEL {
        static let ProcessNotification = #selector(processNotification(_:))
    }
    
    struct URL {
        static let UdacitySignupURLString = "https://www.udacity.com/account/auth#!/signup"
    }
    
    func addFacebookLoginButton() {
        let facebookLoginButton = FBSDKLoginButton(frame: emailTextField.frame)
        
        facebookLoginButton.frame.origin.y = view.frame.height - 20.0 - emailTextField.frame.height
        facebookLoginButton.delegate = self
        facebookLoginButton.isHidden   = false
        facebookLoginButton.isEnabled  = true
        
        view.addSubview(facebookLoginButton)
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.UdacityLoginResponseDataDidGetSaved,  object: nil)
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.UdacityLogoutResponseDataDidGetSaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.UdacityUserDataDidGetSaved,           object: nil)
    }
    
    func addSubviews() {
        view.addSubview(udacityLogo)
        view.addSubview(loginLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
    }
    
    func cleanup(_ alertTitle: String, alertMessage: String) {
        logoutFromFacebook()
        pleaseWaitView?.stopActivityIndicator()
        presentAlert(alertTitle, message: alertMessage)
    }
    
    func createBackgroundColorGradient() {
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
    
    func logoutFromFacebook() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func initPleaseWaitView() {
        pleaseWaitView = PleaseWaitView(requestingView: view)
        view.addSubview(pleaseWaitView!.dimmedView)
        view.bringSubview(toFront: pleaseWaitView!.dimmedView)
    }
    
    func setTextFieldPlaceholders() {
        emailTextField.leftView                 = UIView(frame: PlaceholderText.InsetRect)
        emailTextField.leftViewMode             = .always
        emailTextField.attributedPlaceholder    = NSAttributedString(string: PlaceholderText.EmailField, attributes: PlaceholderText.Attributes)
        
        passwordTextField.leftView              = UIView(frame: PlaceholderText.InsetRect)
        passwordTextField.leftViewMode          = .always
        passwordTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.PasswordField, attributes: PlaceholderText.Attributes)
    }
    
}



