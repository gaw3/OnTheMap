//
//  UdacityFBAccessToken.swift
//  OnTheMap
//
//  Created by Gregory White on 1/22/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

import FBSDKLoginKit

internal struct UdacityFBAccessToken {

	// MARK: - Private Constants

	private struct API {
		static let FBMobileKey    = "facebook_mobile"
		static let AccessTokenKey = "access_token"
	}

	// MARK: - Private Stored Variables

	private var _dict: JSONDictionary

	// MARK: - Internal Computed Meta Variables

	internal var serializedData: NSData {
		let data = try! NSJSONSerialization.dataWithJSONObject(_dict, options: .PrettyPrinted)
		return data
	}

	// MARK: - API

	internal init(accessToken: FBSDKAccessToken) {
		_dict = [ API.FBMobileKey: [ API.AccessTokenKey: accessToken.tokenString ] ]
	}
	
}