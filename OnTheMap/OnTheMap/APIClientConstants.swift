//
//  APIClientConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 12/1/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

struct HTTP {
    
    struct HeaderField {
        static let Accept      = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct Method {
        static let Delete = "DELETE"
        static let Get    = "GET"
        static let Post   = "POST"
        static let Put    = "PUT"
    }
    
    struct MIMEType {
        static let ApplicationJSON = "application/json"
    }
    
}

struct LocalizedError {
    static let Domain          = "OnTheMapExternalAPIInterfaceError"
    static let UdacityHostName = "www.udacity.com"
    
    struct Code {
        static let Network           = 1
        static let HTTP              = 2
        static let JSON              = 3
        static let JSONSerialization = 4
    }
    
    struct Description {
        static let Network           = "Network Error"
        static let HTTP              = "HTTP Error"
        static let JSON	             = "JSON Error"
        static let JSONSerialization = "JSON JSONSerialization Error"
    }
    
}

