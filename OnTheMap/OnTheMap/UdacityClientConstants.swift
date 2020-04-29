//
//  UdacityClientConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 2/3/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

extension UdacityClient {
    
    enum URL {
        static let session               = "https://onthemap-api.udacity.com/v1/session"
        static let user                  = "https://onthemap-api.udacity.com/v1/users/"
        static let getStudentLocations   = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updateAt"
        static let createStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let signupForUdacity      = "https://auth.udacity.com/sign-up"
        
        static func updateStudentLocation(forObjectID id: String) -> String {
            return "\(createStudentLocation)/\(id)"
        }
        
        static func getStudentLocation(forUserID id: String) -> String {
            return "\(createStudentLocation)/\(id)"
        }
        
    }
    
    enum XSRFTokenField {
        static let name       = "X-XSRF-TOKEN"
        static let cookieName = "XSRF-TOKEN"
    }
    
}
