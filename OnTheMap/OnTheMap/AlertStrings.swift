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
        static let BadUserID          = "invalid user account ID"
        static let CheckLoginFields   = "check email & password fields"
        static let HTTPError          = "problem communicating with server"
        static let IsUpdateDesired    = "would you like to update your location?"
        static let LocationNotEntered = "Location not yet entered"
        static let MalformedURL       = "malformed URL"
        static let NetworkUnavailable = "network is unavailable"
        static let NoJSONData         = "JSON data unavailable"
        static let NoPlacemarks       = "did not receive any placemarks"
        static let URLNotEntered      = "Link to share not yet entered"
    }
    
    struct Title {
        static let AlreadyPosted       = "Your Location is Already Posted"
        static let BadFBAuth           = "Facebook Authentication Failed"
        static let BadGeocode          = "Unable to Geocode location"
        static let BadGet              = "Unable to Get Student Location"
        static let BadLogin            = "Unable to Login"
        static let BadLogout           = "Unable to Logout"
        static let BadPost             = "Unable to Post New Student Location"
        static let BadRefresh          = "Unable to Refresh List of Student Locations"
        static let BadSubmit           = "Unable to submit student location update"
        static let BadUpdate           = "Unable to Update Student Location"
        static let BadUserLoginData    = "Login User Data Insufficient"
        static let BadUserProfileData  = "Unable to retrieve user profile"
        static let UnableToOpenBrowser = "Unable to Open Browser"
    }
    
}
