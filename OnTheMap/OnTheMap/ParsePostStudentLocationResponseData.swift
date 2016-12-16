//
//  ParsePostStudentLocationResponseData.swift
//  OnTheMap
//
//  Created by Gregory White on 1/18/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

internal struct ParsePostStudentLocationResponseData {
    
    // MARK: - Private Stored Variables
    
    fileprivate var _data: JSONDictionary
    
    // MARK: - Internal Computed Variables
    
    internal var dateCreated: String? {
        if let date = _data[ParseAPIClient.API.DateCreatedKey] as! String? { return date }
        return nil
    }
    
    internal var id: String? {
        if let id = _data[ParseAPIClient.API.ObjectIDKey] as! String? { return id }
        return nil
    }
    
    // MARK: - API
    
    internal init(dict: JSONDictionary) { _data = dict }
}
