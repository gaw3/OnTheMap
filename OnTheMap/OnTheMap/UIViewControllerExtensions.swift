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
    
    func goToWebsite(withURLString urlString: String) {
        
        guard let urlComponents = URLComponents(string: urlString) else {
            presentAlert(title: "Bad URL", message: "The following URL is malformed:  \(urlString)")
            return
        }
        
        guard UIApplication.shared.canOpenURL(urlComponents.url!) else {
            presentAlert(title: "Bad URL", message: "Your device does not contain an app that can handle the following URL:  \(urlComponents.url!)")
            return
        }
        
        UIApplication.shared.open(urlComponents.url!, completionHandler: nil)
    }
    
    func openSystemBrowser(withURLString urlString: String) {
        
        if let URLComponents = URLComponents(string: urlString) {
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
