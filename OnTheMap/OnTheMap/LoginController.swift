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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func login() {

        guard !emailField.text!.isEmpty else {
            presentAlert(title: Alert.Title.BadUserLoginData, message: "Email address field is empty")
            return
        }
        
        guard isValidEmail(emailField.text!) else {
            presentAlert(title: Alert.Title.BadUserLoginData, message: "Email address is malformed")
            return
        }
        
        guard !passwordField.text!.isEmpty else {
            presentAlert(title: Alert.Title.BadUserLoginData, message: "Password field is empty")
            return
        }
        
        activityIndicator.startAnimating()
        
        UdacityClient.shared.login(username: emailField.text!,
                                   password: passwordField.text!,
                          completionHandler: processUdacityLoginResponse)
    }
    
    func signUp() {
        goToWebsite(withURLString: "https://auth.udacity.com/sign-up")
    }
    
}



private extension LoginController{
    
    var processUdacityLoginResponse: NetworkTaskCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else{
                // need a alert thingy here
                print("\(error!)")
                return
            }
            
            let decoder = JSONDecoder()
 
            dataMgr.udacityLoginResponse = try! decoder.decode(UdacityLoginResponse.self, from: result as! Data)

            DispatchQueue.main.async(execute: {
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.performSegue(withIdentifier: "SegueToTabBarController", sender: nil)
           })

        }

    }
    
}
