//
//  AlertStrings.swift
//  OnTheMap
//
//  Created by Gregory White on 12/15/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct Alert {
    
    struct Message {
        static let LocationNotEntered = "Location not yet entered"
        static let NoJSONData         = "JSON data unavailable"
        static let NoPlacemarks       = "Did not receive any placemarks"
        static let URLNotEntered      = "Link to share not yet entered"
    }
    
    struct Title {
        static let BadGeocode = "Unable to geocode location"
        static let BadPost    = "Unable to post new student location"
        static let BadUpdate  = "Unable to update student location"
        static let BadSubmit  = "Unable to submit student location update"
    }
    
}
