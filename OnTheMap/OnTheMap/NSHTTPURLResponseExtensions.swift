//
//  NSHTTPURLResponseExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import Foundation

extension (NSHTTPURLResponse) {

	enum HTTPStatusCodeClass: Int {
		case Informational = 1,
		     Successful,
		     Redirection,
		     ClientError,
		     ServerError
	}

	var statusCodeClass: HTTPStatusCodeClass {

		if let scClass = HTTPStatusCodeClass.init(rawValue: self.statusCode / 100) {
			return scClass
		} else {
			return .ServerError
		}

	}

}