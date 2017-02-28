//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Gregory White on 1/11/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

struct UdacityUser {
    
    // MARK: - Variables
    
    private var _user: JSONDictionary? = nil
    
    // MARK: - Variables
    
    var firstName: String {
        if let _ = _user, let name = _user![UdacityAPIClient.API.FirstNameKey] as! String? { return name }
        return String()
    }
    
    var fullName: String {
        var fullName = String()
        
        if !firstName.isEmpty { fullName.append(firstName) }
        
        if !lastName.isEmpty {
            if !fullName.isEmpty { fullName.append(" ") }
            
            fullName.append(lastName)
        }
        
        return fullName
    }
    
    var lastName: String {
        if let _ = _user, let name = _user![UdacityAPIClient.API.LastNameKey] as! String? { return name }
        return String()
    }
    
    var userID: String {
        if let _ = _user, let id = _user![UdacityAPIClient.API.UserIDKey] as! String? { return id }
        return String()
    }
    
    // MARK: - API
    
    init(userDict: JSONDictionary) {
        
        if let user = userDict[UdacityAPIClient.API.UserKey] as! JSONDictionary? {
            _user = user
        }
        
    }
    
}
