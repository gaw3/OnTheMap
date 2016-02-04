//
//  ParseAPIClientConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 2/3/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

// MARK: - Public Constants

struct ParseAPI {
	static let BaseURL        = "https://api.parse.com/1/classes/StudentLocation"

	static let DateCreatedKey = "createdAt"
	static let DateUpdatedKey = "updatedAt"
	static let FirstNameKey   = "firstName"
	static let LastNameKey    = "lastName"
	static let LatKey			  = "latitude"
	static let MapStringKey   = "mapString"
	static let LongKey		  = "longitude"
	static let MediaURLKey    = "mediaURL"
	static let ObjectIDKey    = "objectId"
	static let ResultsKey     = "results"
	static let UniqueKeyKey   = "uniqueKey"
}
