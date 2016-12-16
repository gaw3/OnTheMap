//
//  UdacityAPIClientConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 2/3/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

extension UdacityAPIClient {
    
    // MARK: - Internal Constants
    
    internal struct API {
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
    
}
