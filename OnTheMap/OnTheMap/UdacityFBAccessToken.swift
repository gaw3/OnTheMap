//
//  UdacityFBAccessToken.swift
//  OnTheMap
//
//  Created by Gregory White on 1/22/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

import FBSDKLoginKit

struct UdacityFBAccessToken {

	// MARK: - Public Constants

	struct API {
		static let FBMobileKey = "facebook_mobile"
		static let AccessTokenKey = "access_token"
	}

	// MARK: - Private Stored Variables

	private var _dict: JSONDictionary

	// MARK: - Public Computed Meta Variables

	var serializedData: NSData {
		get {
			let data = try! NSJSONSerialization.dataWithJSONObject(_dict, options: .PrettyPrinted)
			return data
		}
	}

	// MARK: - API

	init(accessToken: FBSDKAccessToken) {
		print("access Token String = \(accessToken.tokenString)")
		_dict = [ API.FBMobileKey : [ API.AccessTokenKey : accessToken.tokenString ] ]
	}
	
}