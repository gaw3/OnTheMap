//
//  UdacityAPIClientConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 2/3/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

extension UdacityClient {
    
    struct API {
        static let BaseURL           = "https://www.udacity.com/api/"
        static let SessionURL        = BaseURL + "session"
        static let UsersURL          = BaseURL + "users/"
        
        static let AccountKey        = "account"
        static let ExpirationDateKey = "expiration"
        static let FirstNameKey      = "first_name"
        static let LastNameKey       = "last_name"
        static let PasswordKey       = "password"
        static let RegisteredKey     = "registered"
        static let SessionIDKey      = "id"
        static let SessionKey        = "session"
        static let UdacityKey        = "udacity"
        static let UserIDKey         = "key"
        static let UserKey		     = "user"
        static let UserNameKey       = "username"
    }
    
    struct XSRFTokenField {
        static let Name       = "X-XSRF-TOKEN"
        static let CookieName = "XSRF-TOKEN"
    }
    
}


extension UdacityClient {
    
    enum URL {
        static let session = "https://onthemap-api.udacity.com/v1/session"
        static let user    = "https://onthemap-api.udacity.com/v1/users/"
        static let getStudentLocations   = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updateAt"
        static let createStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        static func updateStudentLocation(forObjectID id: String) -> String {
            return "\(createStudentLocation)/\(id)"
        }
        
        static func getStudentLocation(forUserID id: String) -> String {
            return "\(createStudentLocation)/\(id)"
        }
    }
    
}
