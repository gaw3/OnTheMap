//
//  UdacityLogin.swift
//  OnTheMap
//
//  Created by Gregory White on 1/19/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

internal struct UdacityLogin {

	// MARK: - Private Stored Variables

	private var _udacity: JSONDictionary

	// MARK: - Internal Computed Meta Variables

	internal var serializedData: NSData {
		let data = try! NSJSONSerialization.dataWithJSONObject(_udacity, options: .PrettyPrinted)
		return data
	}

	// MARK: - API

	internal init(username: String, password: String) {
		_udacity = [ UdacityAPIClient.API.UdacityKey: [ UdacityAPIClient.API.UserNameKey: username,
																	   UdacityAPIClient.API.PasswordKey: password ] ]
	}
	
}