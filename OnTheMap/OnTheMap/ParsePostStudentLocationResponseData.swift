//
//  ParsePostStudentLocationResponseData.swift
//  OnTheMap
//
//  Created by Gregory White on 1/18/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

struct ParsePostStudentLocationResponseData {
    
    // MARK: - Variables
    
    private var _data: JSONDictionary
    
    var dateCreated: String {
        if let date = _data[ParseAPIClient.API.DateCreatedKey] as! String? { return date }
        return String()
    }
    
    var id: String {
        if let id = _data[ParseAPIClient.API.ObjectIDKey] as! String? { return id }
        return String()
    }
    
    // MARK: - API
    
    init(dict: JSONDictionary) { _data = dict }
}
