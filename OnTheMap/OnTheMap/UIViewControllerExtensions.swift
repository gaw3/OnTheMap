//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - API
    
    func openSystemBrowserWithURL(_ URLString: String) {
        
        if let URLComponents = URLComponents(string: URLString) {
            UIApplication.shared.open(URLComponents.url!, options: [:], completionHandler: nil)
        } else {
            presentAlert(title: Alert.Title.UnableToOpenBrowser, message: Alert.Message.MalformedURL)
        }
        
    }
    
    func presentAlert(title: String, message: String) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Alert.ActionTitle.OK, style: .default, handler: nil)
        alert.addAction(action)
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
}
