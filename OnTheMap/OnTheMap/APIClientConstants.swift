//
//  APIClientConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 12/1/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

enum HTTP {
    
    enum HeaderField {
        static let accept      = "Accept"
        static let contentType = "Content-Type"
    }
    
    enum Method {
        static let delete = "DELETE"
        static let get    = "GET"
        static let post   = "POST"
        static let put    = "PUT"
    }
    
    enum MIMEType {
        static let applicationJSON = "application/json"
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

