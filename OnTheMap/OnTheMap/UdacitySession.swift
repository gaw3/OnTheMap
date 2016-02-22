//
//  UdacitySession.swift
//  OnTheMap
//
//  Created by Gregory White on 1/14/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

internal struct UdacitySession {

	// MARK: - Private Stored Variables

	private var _session: JSONDictionary

	// MARK: - Internal Computed Variables

	internal var expirationDate: String? {
		if let date = _session[UdacityAPIClient.API.ExpirationDateKey] as! String? { return date }
		return nil
	}

	internal var id: String? {
		if let id = _session[UdacityAPIClient.API.SessionIDKey] as! String? { return id }
		return nil
	}

	// MARK: - API

	internal init(sessionDict: JSONDictionary) { _session = sessionDict }
}
