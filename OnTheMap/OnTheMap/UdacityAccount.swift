//
//  UdacityAccount.swift
//  OnTheMap
//
//  Created by Gregory White on 1/14/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

struct UdacityAccount {

	// MARK: - Private Stored Variables

	private var _account: JSONDictionary
	
	// MARK: - Public Computed Variables

	var isRegistered: Bool {
		if let isRegistered = _account[UdacityAPIClient.API.RegisteredKey] as! Bool? { return isRegistered }
		return false
	}
	
	var userID: String? {
		if let userID = _account[UdacityAPIClient.API.UserIDKey] as! String? { return userID }
		return nil
	}

	// MARK: - API

	init(accountDict: JSONDictionary) { _account = accountDict }
}