//
//  LoginController.swift
//  OnTheMap
//
//  Created by Gregory White on 3/13/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import UIKit

final class LoginController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var emailField:        UITextField!
    @IBOutlet weak var passwordField:     UITextField!
    @IBOutlet weak var loginButton:       UIButton!
    @IBOutlet weak var signUpButton:      UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - IB Actions
    
    @IBAction func didTouchUpInside(_ button: UIButton) {
        
        switch button {
        case loginButton:  login()
        case signUpButton: signUp()
        default: assertionFailure("Received event from unknown button")
        }
        
    }
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .newCannedLocationsAvailable,
                                                       object: nil)
    }
    
}



// MARK: -
// MARK: - Notifications

extension LoginController {
    
    @objc func process(notification: Notification) {
        
        DispatchQueue.main.async(execute: {

            switch notification.name {
            
            case .newCannedLocationsAvailable:
                NotificationCenter.default.removeObserver(self, name: .newCannedLocationsAvailable,
                                                              object: nil)
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: String.SegueID.toTabBarController, sender: nil)

            default: assertionFailure("Received unknown notification = \(notification)")
            }
            
        })
        
    }
    
}



// MARK: -
// MARK: - Text Field Delegate

extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension LoginController {
    
    func login() {

        guard !emailField.text!.isEmpty else {
            presentAlert(title: .badUserLoginData, message: .noEmailAddress)
            return
        }
        
        guard emailField.text!.isValidEmail else {
            presentAlert(title: .badUserLoginData, message: .badEmailAddress)
            return
        }
        
        guard !passwordField.text!.isEmpty else {
            presentAlert(title: .badUserLoginData, message: .noPassword)
            return
        }
        
        activityIndicator.startAnimating()
        
        UdacityClient.shared.login(username: emailField.text!,
                                   password: passwordField.text!,
                          completionHandler: processUdacityLoginResponse)
    }
    
    func signUp() {
        goToWebsite(withURLString: UdacityClient.URL.signupForUdacity)
    }
    
}



// MARK: -
// MARK: - Private Completion Handlers

private extension LoginController{
    
    var processUdacityLoginResponse: NetworkTaskCompletionHandler {
        
        return { (result, error) -> Void in
            #warning("take care of this error handling")
            guard error == nil else{
                // need a alert thingy here
                print("\(error!)")
                return
            }
            
            let decoder = JSONDecoder()
 
            dataMgr.udacityLoginResponse = try! decoder.decode(UdacityLoginResponse.self, from: result as! Data)
            dataMgr.refreshCannedLocations()
        }

    }
    
}
