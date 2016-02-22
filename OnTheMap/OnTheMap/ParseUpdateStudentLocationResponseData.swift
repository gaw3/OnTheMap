//
//  ParseUpdateStudentLocationResponseData.swift
//  OnTheMap
//
//  Created by Gregory White on 1/18/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

struct ParseUpdateStudentLocationResponseData {

	// MARK: - Private Stored Variables

	private var _data: JSONDictionary

	// MARK: - Public Computed Variables

	var dateUpdated: String? {
		get {
			if let date = _data[ParseAPIClient.API.DateUpdatedKey] as! String? { return date }
			return nil
		}
	}

	// MARK: - API

	init(dict: JSONDictionary) { _data = dict }
}
