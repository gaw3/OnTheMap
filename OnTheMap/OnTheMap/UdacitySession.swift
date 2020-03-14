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
        if let date = _session[UdacityClient.API.ExpirationDateKey] as! String? { return date }
        return String()
    }
    
    var id: String {
        if let id = _session[UdacityClient.API.SessionIDKey] as! String? { return id }
        return String()
    }
    
    // MARK: - API
    
    init(sessionDict: JSONDictionary) { _session = sessionDict }
}

struct UdacityLoginData: Encodable {
    let udacity: Udacity
    
    struct Udacity: Encodable {
        let username: String
        let password: String
    }
    
}

struct UdacityLoginResponse: Decodable {
    let account: Account
    let session: Session
    
    struct Account: Decodable {
        let registered: Bool
        let key:        String
    }

    struct Session: Decodable {
        let id:         String
        let expiration: String
    }
    
}

