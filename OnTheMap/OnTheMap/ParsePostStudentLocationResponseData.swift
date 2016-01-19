//
//  ParsePostStudentLocationResponseData.swift
//  OnTheMap
//
//  Created by Gregory White on 1/18/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct ParsePostStudentLocationResponseData {
	
	// MARK: - Private Stored Variables

	private var _data: JSONDictionary

	// MARK: - Public Computed Variables

	var dateCreated: String? {
		get {
			if let date = _data[ParseAPIClient.API.DateCreatedKey] as! String? { return date }
			return nil
		}
	}

	var id: String? {
		get {
			if let id = _data[ParseAPIClient.API.ObjectIDKey] as! String? { return id }
			return nil
		}
	}

	// MARK: - API

	init(dict: JSONDictionary) { _data = dict }
}
