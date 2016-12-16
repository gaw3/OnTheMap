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
    
    fileprivate struct API {
        static let FBMobileKey    = "facebook_mobile"
        static let AccessTokenKey = "access_token"
    }
    
    // MARK: - Private Stored Variables
    
    fileprivate var _dict: JSONDictionary
    
    // MARK: - Internal Computed Meta Variables
    
    internal var serializedData: Data {
        let data = try! JSONSerialization.data(withJSONObject: _dict, options: .prettyPrinted)
        return data
    }
    
    // MARK: - API
    
    internal init(accessToken: FBSDKAccessToken) {
        _dict = [ API.FBMobileKey: [ API.AccessTokenKey: accessToken.tokenString ] as AnyObject ]
    }
    
}
