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
            presentAlert(title: .badURL, message: .badURL)
            return
        }
        
        guard UIApplication.shared.canOpenURL(urlComponents.url!) else {
            presentAlert(title: .badURL, message: .noApp)
            return
        }
        
        UIApplication.shared.open(urlComponents.url!, completionHandler: nil)
    }
    
    func presentAlert(title: String.AlertTitle, message: String.AlertMessage) {
        let alert  = UIAlertController(title: title.rawValue, message: message.rawValue, preferredStyle: .alert)
        let action = UIAlertAction(title: String.ActionTitle.ok, style: .default, handler: nil)
        alert.addAction(action)
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
}
