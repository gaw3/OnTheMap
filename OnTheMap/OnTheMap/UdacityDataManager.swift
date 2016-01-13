//
//  UdacityDataManager.swift
//  OnTheMap
//
//  Created by Gregory White on 1/11/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

private let _sharedMgr = UdacityDataManager()

class UdacityDataManager: NSObject {

	class var sharedMgr: UdacityDataManager {
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

	var isLogoutSuccessful: Bool {
		get { return (logoutResponseData != nil) }
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

	private var loginResponseData:  UdacityLoginResponseData? = nil
	private var logoutResponseData: UdacityLogoutResponseData? = nil
	private var userData:           UdacityUserData? = nil

	// MARK: - API

	func setLoginResponseData(data: UdacityLoginResponseData) {
		loginResponseData = data
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.LoginResponseDataDidGetSaved, object: nil)
	}

	func setLogoutResponseData(data: UdacityLogoutResponseData) {
		logoutResponseData = data
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.LogoutResponseDataDidGetSaved, object: nil)
	}

	func setUserData(data: UdacityUserData) {
		userData = data
		NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.UserDataDidGetSaved, object: nil)
	}

	// MARK: - Private

	private override init() {
		super.init()
	}
	
}

