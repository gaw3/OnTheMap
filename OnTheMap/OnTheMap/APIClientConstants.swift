//
//  APIClientConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 12/1/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import Foundation

// MARK: - Public Constants

struct HTTPHeaderField {
	static let Accept      = "Accept"
	static let ContentType = "Content-Type"
}

struct HTTPMethod {
	static let Delete = "DELETE"
	static let Get    = "GET"
	static let Post   = "POST"
	static let Put    = "PUT"
}

struct MIMEType {
	static let ApplicationJSON = "application/json"
}
