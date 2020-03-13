//
//  UdacityLoginViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

//import FBSDKCoreKit
//import FBSDKLoginKit

final class UdacityLoginViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var udacityLogo:       UIImageView!
    @IBOutlet weak var loginLabel:        UILabel!
    @IBOutlet weak var emailTextField:    UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton:	      UIButton!
    @IBOutlet weak var signUpButton:      UIButton!
    
    // MARK: - IB Actions
    
    @IBAction func buttonDidTouchUpInside(_ button: UIButton) {
        switch button {
        case loginButton: login()
        case signUpButton: openSystemBrowser(withURLString: URL.UdacitySignup)
        default: fatalError("Received action from unknown button = \(button)")
        }
    }
    
    @IBAction func unwindToLoginViewController(_ segue: UIStoryboardSegue) {
        emailTextField.text    = String()
        passwordTextField.text = String()
        
//        logoutFromFacebook()
        UdacityClient.shared.logout(completionHandler: finishLoggingOut)
    }
    
    // MARK: - Variables
    
    fileprivate var pleaseWaitView: PleaseWaitView? = nil
    
    private lazy var foo: Void = {
//        self.addFacebookLoginButton()
        self.initPleaseWaitView()
    }()
    
    // MARK: - View Events
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeNotificationObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _ = foo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setTextFieldPlaceholders()
        createBackgroundColorGradient()
        
        loginLabel.textColor = UIColor.white
        signUpButton.setTitleColor(UIColor.white, for: UIControl.State())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotificationObservers()
    }

}



// MARK: -
// MARK: - Facebook SDK Login Button Delegate

//extension UdacityLoginViewController: FBSDKLoginButtonDelegate {
//    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        
//        if let _ = error {
//            self.presentAlert(title: Alert.Title.BadFBAuth, message: error!.localizedDescription)
//        } else if let token = result.token {
//            pleaseWaitView?.startActivityIndicator()
//            UdacityClient.shared.login(facebookAccessToken: token, completionHandler: finishLoggingIn)
//        }
//        
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        // must have this to satisfy the protocol
//    }
//    
//}



// MARK: -
// MARK: - Notifications

extension UdacityLoginViewController {
    
    @objc func processNotification(_ notification: Notification) {
        
        switch notification.name {
            
        case Notifications.UdacityLoginResponseDataDidGetSaved:
            UdacityClient.shared.getProfileData(forUserID: UdacityDataManager.shared.account!.userID, completionHandler: finishGettingProfileData)
            
        case Notifications.UdacityLogoutResponseDataDidGetSaved: break
            
        case Notifications.UdacityUserDataDidGetSaved:
            pleaseWaitView?.stopActivityIndicator()
            
            if UdacityDataManager.shared.isLoginSuccessful {
                
                DispatchQueue.main.async(execute:  {
//                    self.performSegue(withIdentifier: "SegueFromLoginToNavCtlr", sender: self)
                    
                    let navController = self.storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.StudentLocsTabBarNC) as! UINavigationController
                    self.present(navController, animated: true, completion: nil)
                })
                
            }
            
        default: fatalError("Received unknown notification = \(notification)")
        }
        
    }
    
}



// MARK: -
// MARK: - Text Field Delegate

extension UdacityLoginViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        assert(textField == emailTextField || textField == passwordTextField, "unknown UITextField = \(textField)")
        
        textField.resignFirstResponder()
        return true
    }
    
}



// MARK: -
// MARK: - Private Completion Handlers

private extension UdacityLoginViewController {
    
    var finishGettingProfileData: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }

            guard error == nil else {
                var message = String()
                
                switch error!.code {
                case LocalizedError.Code.Network: message = Alert.Message.NetworkUnavailable
                case LocalizedError.Code.HTTP:    message = Alert.Message.BadLoginData
                default:                          message = Alert.Message.BadServerData
                }
                
                strongSelf.cleanup(alertTitle: Alert.Title.BadLogin, alertMessage: message)
                return
            }
            
            UdacityDataManager.shared.user = UdacityUser(userDict: result as! JSONDictionary)
        }
        
    }
    
    var finishLoggingIn: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                var message = String()
                
                switch error!.code {
                case LocalizedError.Code.Network: message = Alert.Message.NetworkUnavailable
                case LocalizedError.Code.HTTP:    message = Alert.Message.BadLoginData
                default:                          message = Alert.Message.BadServerData
                }
                
                strongSelf.cleanup(alertTitle: Alert.Title.BadLogin, alertMessage: message)
                return
            }
            
            let JSONResult = result as! JSONDictionary
            
            let account = UdacityAccount(accountDict: JSONResult[UdacityClient.API.AccountKey] as! JSONDictionary)
            let session = UdacitySession(sessionDict: JSONResult[UdacityClient.API.SessionKey] as! JSONDictionary)
            
            UdacityDataManager.shared.loginData = (account, session)
        }
        
    }
    
    var finishLoggingOut: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                var message = String()
                
                switch error!.code {
                case LocalizedError.Code.Network: message = Alert.Message.NetworkUnavailable
                case LocalizedError.Code.HTTP:    break
                default:                          message = Alert.Message.BadServerData
                }
                
                strongSelf.cleanup(alertTitle: Alert.Title.BadLogout, alertMessage: message)
                return
            }
            
            UdacityDataManager.shared.logoutData = UdacitySession(sessionDict: result as! JSONDictionary)
        }
        
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension UdacityLoginViewController {
    
    struct URL {
        static let UdacitySignup = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: - Facebook
    
//    func addFacebookLoginButton() {
//        let facebookLoginButtonFrame = CGRect(x: emailTextField.frame.origin.x, y: view.frame.height - 48.0, width: emailTextField.frame.width, height: 28.0)
//        let facebookLoginButton      = FBSDKLoginButton(frame: facebookLoginButtonFrame)
//        
//        facebookLoginButton.delegate   = self
//        facebookLoginButton.isHidden   = false
//        facebookLoginButton.isEnabled  = true
//        
//        view.addSubview(facebookLoginButton)
//    }
//    
//    func logoutFromFacebook() {
//        let loginManager = FBSDKLoginManager()
//        loginManager.logOut()
//    }
    
    // MARK: - Notifications
    
    struct SEL {
        static let ProcessNotification = #selector(processNotification(_:))
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.UdacityLoginResponseDataDidGetSaved,  object: nil)
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.UdacityLogoutResponseDataDidGetSaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.UdacityUserDataDidGetSaved,           object: nil)
    }
    
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: Notifications.UdacityLoginResponseDataDidGetSaved,  object: nil)
        NotificationCenter.default.removeObserver(self, name: Notifications.UdacityLogoutResponseDataDidGetSaved, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notifications.UdacityUserDataDidGetSaved,           object: nil)
    }
    
    // MARK: - Views

    struct PlaceholderText {
        static let Attributes    = [NSAttributedString.Key.foregroundColor: UIColor.white]
        static let EmailField    = "Email"
        static let InsetRect     = CGRect(x: 0, y: 0, width: 10, height: 50)
        static let PasswordField = "Password"
    }
    
    func addSubviews() {
        view.addSubview(udacityLogo)
        view.addSubview(loginLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
    }
    
    func cleanup(alertTitle: String, alertMessage: String) {
//        logoutFromFacebook()
        pleaseWaitView?.stopActivityIndicator()
        presentAlert(title: alertTitle, message: alertMessage)
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
    
    func initPleaseWaitView() {
        pleaseWaitView = PleaseWaitView(requestingView: view)
        view.addSubview(pleaseWaitView!.dimmedView)
        view.bringSubviewToFront(pleaseWaitView!.dimmedView)
    }
    
    func setTextFieldPlaceholders() {
        emailTextField.leftView                 = UIView(frame: PlaceholderText.InsetRect)
        emailTextField.leftViewMode             = .always
        emailTextField.attributedPlaceholder    = NSAttributedString(string: PlaceholderText.EmailField, attributes: PlaceholderText.Attributes)
        
        passwordTextField.leftView              = UIView(frame: PlaceholderText.InsetRect)
        passwordTextField.leftViewMode          = .always
        passwordTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.PasswordField, attributes: PlaceholderText.Attributes)
    }
    
    // MARK: - Udacity
    
    func login() {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            presentAlert(title: Alert.Title.BadUserLoginData, message: Alert.Message.CheckLoginFields)
        } else {
            pleaseWaitView?.startActivityIndicator()
            UdacityClient.shared.login(username: emailTextField.text! as String, password: passwordTextField.text! as String, completionHandler: finishLoggingIn)
        }
        
    }
    
}



