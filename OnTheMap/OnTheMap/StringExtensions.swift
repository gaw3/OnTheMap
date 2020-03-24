//
//  StringExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 3/18/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import Foundation
import UIKit

// MARK: -
// MARK: -

extension Notification.Name {
    static let newAddedLocationsAvailable  = Notification.Name(rawValue: "NewAddedLocationsAvailable")
    static let newCannedLocationsAvailable = Notification.Name(rawValue: "NewCannedLocationsAvailable")
}

// MARK: -
// MARK: -

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    var isValidURL: Bool {
        
        guard let urlComponents = URLComponents(string: self) else {
            return false
        }
        
        guard UIApplication.shared.canOpenURL(urlComponents.url!) else {
             return false
        }

        return true
    }
    
    enum ActionTitle {
        static let no  = "No"
        static let ok  = "OK"
        static let yes = "Yes"
    }
    
    enum AlertTitle: String {
        case badGeocode       = "Unable to geocode location"
        case badUserLoginData = "Login User Data Insufficient"
        case badUserInput     = "Invalid Input Data"
        case badURL           = "Bad URL"
    }
    
    enum AlertMessage: String {
        case badEmailAddress = "Email address is malformed"
        case badURL          = "The URL string is malformed"
        case noApp           = "Your device does not contain an app that can handle the URL"
        case noEmailAddress  = "Email address field is empty"
        case noFirstName     = "First name field is empty"
        case noLastName      = "Last name field is empty"
        case noLocation      = "Location field is empty"
        case noPassword      = "Password field is empty"
        case noPlacemarks    = "Did not receive any placemarks"
        case noURL           = "URL field is empty"
        case serverError     = "Server Error"
    }
    
    enum ReuseID {
        static let annotationView = "AnnotationView"
        static let listCell       = "ListCell"
    }
    
    enum SegueID {
        static let toTabBarController       = "SegueToTabBarController"
        static let unwindToTabBarController = "UnwindSegueToTabBarController"
    }
    
    enum StoryboardID {
        static let listControllerNC = "ListControllerNC"
        static let mapControllerNC  = "MapControllerNC"
        static let verifyLocationVC = "VerifyLocationVC"
    }
    
}
