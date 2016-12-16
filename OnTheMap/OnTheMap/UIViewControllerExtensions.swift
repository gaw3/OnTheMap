//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Private Constants
    
    fileprivate struct Alert {
        static let ActionTitle = "OK"
        static let Message     = "Malformed URL"
        static let Title       = "Unable to open browser"
    }
    
    // MARK: - Internal Computed Variables
    
    internal var notifCtr: NotificationCenter{
        return NotificationCenter.default
    }
    
    internal var parseClient: ParseAPIClient {
        return ParseAPIClient.sharedClient
    }
    
    internal var slMgr: StudentLocationsManager {
        return StudentLocationsManager.sharedMgr
    }
    
    internal var udacityDataMgr: UdacityDataManager {
        return UdacityDataManager.sharedMgr
    }
    
    // MARK: - API
    
    internal func openSystemBrowserWithURL(_ URLString: String) {
        var success = false
        
        if let URLComponents = URLComponents(string: URLString) {
            UIApplication.shared.open(URLComponents.url!, options: [:], completionHandler: nil)
        }
        
        //		if !success {
        //			presentAlert(Alert.Title, message: Alert.Message)
        //		}
        
    }
    
    internal func presentAlert(_ title: String, message: String) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Alert.ActionTitle, style: .default, handler: nil)
        alert.addAction(action)
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
    
}
