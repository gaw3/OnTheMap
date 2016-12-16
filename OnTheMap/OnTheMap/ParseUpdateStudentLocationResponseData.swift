//
//  ParseUpdateStudentLocationResponseData.swift
//  OnTheMap
//
//  Created by Gregory White on 1/18/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

struct ParseUpdateStudentLocationResponseData {
    
    // MARK: - Variables
    
    private var _data: JSONDictionary
    
    var dateUpdated: String {
        if let date = _data[ParseAPIClient.API.DateUpdatedKey] as! String? { return date }
        return String()
    }
    
    // MARK: - API
    
    init(dict: JSONDictionary) { _data = dict }
}
