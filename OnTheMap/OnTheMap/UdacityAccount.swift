//
//  UdacityAccount.swift
//  OnTheMap
//
//  Created by Gregory White on 1/14/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

struct UdacityAccount {
    
    // MARK: - Variables
    
    private var _account: JSONDictionary
    
    var isRegistered: Bool {
        if let isRegistered = _account[UdacityClient.API.RegisteredKey] as! Bool? { return isRegistered }
        return false
    }
    
    var userID: String {
        if let userID = _account[UdacityClient.API.UserIDKey] as! String? { return userID }
        return String()
    }
    
    // MARK: - API
    
    init(accountDict: JSONDictionary) { _account = accountDict }
}
