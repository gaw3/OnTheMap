//
//  NSHTTPURLResponseExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 11/24/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

extension NSHTTPURLResponse {

	internal enum HTTPStatusCodeClass: Int {
		case Informational = 1,
		     Successful,
		     Redirection,
		     ClientError,
		     ServerError
	}

	// MARK: - Internal Computed Variables

	internal var statusCodeClass: HTTPStatusCodeClass {

		if let scClass = HTTPStatusCodeClass.init(rawValue: self.statusCode / 100) {
			return scClass
		} else {
			return .ServerError
		}

	}

}