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

	// MARK: - Public Constants

	struct Notification {
		static let LoginResponseDataDidGetSaved  = "LoginResponseDataDidGetSavedNotification"
		static let LogoutResponseDataDidGetSaved = "LogoutResponseDataDidGetSavedNotification"
		static let UserDataDidGetSaved           = "UserDataDidGetSavedNotification"
	}

	// MARK: - Private Stored Variables

	private var _account:       UdacityAccount? = nil
	private var _loginSession:  UdacitySession? = nil
	private var _logoutSession: UdacitySession? = nil
	private var _user:          UdacityUser?    = nil
	
	// MARK: - Public Computed Variables

	var account: UdacityAccount? {
		get { return _account }
	}

	var isLoginSuccessful: Bool {
		get {  return ((_account != nil) && (_loginSession != nil)) }
	}

	var isLogoutSuccessful: Bool {
		get {  return (_logoutSession != nil) }
	}

	var loginData: (UdacityAccount?, UdacitySession?) {
		get { return (_account, _loginSession) }

		set(data) {
			_account      = data.0
			_loginSession = data.1
			NSNotificationCenter.defaultCenter().postNotificationName(Notification.LoginResponseDataDidGetSaved, object: nil)
		}
	}

	var logoutData: (UdacitySession) {
		get { return _logoutSession! }

		set(data) {
			_logoutSession = data
			NSNotificationCenter.defaultCenter().postNotificationName(Notification.LogoutResponseDataDidGetSaved, object: nil)
		}
	}
	
	var user: UdacityUser? {
		get { return _user }

		set(newUser) {
			_user = newUser
			NSNotificationCenter.defaultCenter().postNotificationName(Notification.UserDataDidGetSaved, object: nil)
		}
	}
	
	// MARK: - Private

	private override init() {
		super.init()
	}
	
}

