//
//  UdacityUserManager.swift
//  OnTheMap
//
//  Created by Gregory White on 1/11/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

let LoginResponseDataDidGetSavedNotification = "LoginResponseDataDidGetSavedNotification"
let UserDataDidGetSavedNotification          = "UserDataDidGetSavedNotification"

private let _sharedMgr = UdacityUserManager()

class UdacityUserManager: NSObject {

	class var sharedMgr: UdacityUserManager {
		return _sharedMgr
	}

	// MARK: - Public Computed Variables

	var accountUserID: String? {

		get {
			var userID: String? = nil

			if let data = loginResponseData {
				if let id = data.userID {
					userID = id
				}
			}

			return userID
		}

	}

	var isLoginSuccessful: Bool {

		get {
			var success = false

			if let _ = accountUserID {
				if let _ = usersUserID {
					success = (accountUserID == usersUserID)
				}
			}

			return success
		}

	}

	var usersUserID: String? {

		get {
			var userID: String? = nil

			if let data = userData {
				if let id = data.userID {
					userID = id
				}
			}

			return userID
		}
		
	}
	
	// MARK: - Private Stored Variables

	private var loginResponseData: UdacityLoginResponseData? = nil
	private var userData:          UdacityUserData? = nil

	// MARK: - API

	func setLoginResponseData(data: UdacityLoginResponseData) {
		self.loginResponseData = data
		NSNotificationCenter.defaultCenter().postNotificationName(LoginResponseDataDidGetSavedNotification, object: nil)
	}

	func setUserData(data: UdacityUserData) {
		self.userData = data
		NSNotificationCenter.defaultCenter().postNotificationName(UserDataDidGetSavedNotification, object: nil)
	}

	// MARK: - Private

	private override init() {
		super.init()
	}
	
}

