//
//  ParseUpdateStudentLocationResponseData.swift
//  OnTheMap
//
//  Created by Gregory White on 1/18/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

internal struct ParseUpdateStudentLocationResponseData {
    
    // MARK: - Private Stored Variables
    
    fileprivate var _data: JSONDictionary
    
    // MARK: - Internal Computed Variables
    
    internal var dateUpdated: String? {
        if let date = _data[ParseAPIClient.API.DateUpdatedKey] as! String? { return date }
        return nil
    }
    
    // MARK: - API
    
    internal init(dict: JSONDictionary) { _data = dict }
}
