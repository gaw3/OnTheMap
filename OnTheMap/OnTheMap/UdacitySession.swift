//
//  UdacitySession.swift
//  OnTheMap
//
//  Created by Gregory White on 1/14/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

struct UdacitySession {
    
    // MARK: - Variables
    
    private var _session: JSONDictionary
    
    var expirationDate: String {
        if let date = _session[UdacityAPIClient.API.ExpirationDateKey] as! String? { return date }
        return String()
    }
    
    var id: String {
        if let id = _session[UdacityAPIClient.API.SessionIDKey] as! String? { return id }
        return String()
    }
    
    // MARK: - API
    
    init(sessionDict: JSONDictionary) { _session = sessionDict }
}
