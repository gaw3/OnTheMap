//
//  UdacitySession.swift
//  OnTheMap
//
//  Created by Gregory White on 1/14/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct UdacitySession {

	// MARK: - Private Stored Variables

	private var _session: JSONDictionary

	// MARK: - Public Computed Variables

	var expirationDate: String? {
		get {
			if let date = _session[UdacityAPIClient.API.ExpirationDateKey] as! String? { return date }
			return nil
		}
	}

	var id: String? {
		get {
			if let id = _session[UdacityAPIClient.API.SessionIDKey] as! String? { return id }
			return nil
		}
	}

	// MARK: - API

	init(sessionDict: JSONDictionary) { _session = sessionDict }
}
