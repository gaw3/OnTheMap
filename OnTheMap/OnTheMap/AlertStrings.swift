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
        static let No  = "No"
        static let OK  = "OK"
        static let Yes = "Yes"
    }
    
    struct Message {
        static let BadLoginData       = "invalid username/password combination"
        static let BadServerData      = "received malformed server data"
        static let CheckLoginFields   = "check email & password fields"
        static let IsUpdateDesired    = "Would you like to update your location?"
        static let LocationNotEntered = "Location not yet entered"
        static let MalformedURL       = "malformed URL"
        static let NetworkUnavailable = "network unavailable"
        static let NoJSONData         = "JSON data unavailable"
        static let NoPlacemarks       = "Did not receive any placemarks"
        static let URLNotEntered      = "Link to share not yet entered"
    }
    
    struct Title {
        static let AlreadyPosted       = "Your location already posted"
        static let BadFBAuth           = "Facebook authentication failed"
        static let BadGeocode          = "Unable to geocode location"
        static let BadGet              = "Unable to find student location"
        static let BadLogin            = "Unable to Login"
        static let BadLogout           = "Unable to Logout"
        static let BadPost             = "Unable to post new student location"
        static let BadRefresh          = "Unable to refresh list of student locations"
        static let BadSubmit           = "Unable to submit student location update"
        static let BadUpdate           = "Unable to update student location"
        static let BadUserLoginData    = "Login User Data Insufficient"
        static let BadUserProfileData  = "Unable to retrieve user profile"
        static let UnableToOpenBrowser = "Unable to Open Browser"
    }
    
}
