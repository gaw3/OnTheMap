//
//  JSON.swift
//  OnTheMap
//
//  Created by Gregory White on 3/15/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import Foundation

// MARK: -

struct UdacityLoginData: Encodable {
    let udacity: Udacity
    
    struct Udacity: Encodable {
        let username: String
        let password: String
    }
    
}

// MARK: -

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

// MARK: -

struct Locations: Decodable {
    let results: [Location]
    
    struct Location: Decodable {
        let createdAt: String?
        let firstName: String?
        let lastName:  String?
        let latitude:  Double?
        let longitude: Double?
        let mapString: String?
        let mediaURL:  String?
        let objectId:  String?
        let uniqueKey: String?
        let updatedAt: String?
    }

}

