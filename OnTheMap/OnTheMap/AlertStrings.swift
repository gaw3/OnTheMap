//
//  AlertStrings.swift
//  OnTheMap
//
//  Created by Gregory White on 12/15/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct Alert {
    
    struct ActionTitle {
        static let Yes = "Yes"
        static let No  = "No"
    }
    
    struct Message {
        static let CheckLoginFields   = "Check email & password fields"
        static let IsUpdateDesired    = "Would you like to update your location?"
        static let LocationNotEntered = "Location not yet entered"
        static let NoJSONData         = "JSON data unavailable"
        static let NoPlacemarks       = "Did not receive any placemarks"
        static let URLNotEntered      = "Link to share not yet entered"
    }
    
    struct Title {
        static let AlreadyPosted      = "Your location already posted"
        static let BadFBAuth          = "Facebook authentication failed"
        static let BadGeocode         = "Unable to geocode location"
        static let BadGet             = "Unable to find student location"
        static let BadLogin           = "Unable to login"
        static let BadLogout          = "Unable to logout"
        static let BadPost            = "Unable to post new student location"
        static let BadRefresh         = "Unable to refresh list of student locations"
        static let BadSubmit          = "Unable to submit student location update"
        static let BadUpdate          = "Unable to update student location"
        static let BadUserLoginData   = "Login user data insufficient"
        static let BadUserProfileData = "Unable to retrieve user profile"
    }
    
}
