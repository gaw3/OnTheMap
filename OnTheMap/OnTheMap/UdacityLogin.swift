//
//  UdacityLogin.swift
//  OnTheMap
//
//  Created by Gregory White on 1/19/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct UdacityLogin {

	// MARK: - Private Stored Variables

	private var _udacity: JSONDictionary

	// MARK: - Public Computed Meta Variables

	var serializedData: NSData {
		get {
			let data = try! NSJSONSerialization.dataWithJSONObject(_udacity, options: .PrettyPrinted)
			return data
		}
	}

	// MARK: - API

	init(username: String, password: String) {
		_udacity = [ UdacityAPI.UdacityKey : [ UdacityAPI.UserNameKey : username,
																		 UdacityAPI.PasswordKey : password ] ]
	}
	
}