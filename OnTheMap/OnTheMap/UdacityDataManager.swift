//
//  UdacityDataManager.swift
//  OnTheMap
//
//  Created by Gregory White on 1/11/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

private let _sharedMgr = UdacityDataManager()

final internal class UdacityDataManager: NSObject {

	class internal var sharedMgr: UdacityDataManager {
		return _sharedMgr
	}

	// MARK: - Internal Constants

	internal struct Notification {
		static let LoginResponseDataDidGetSaved  = "LoginResponseDataDidGetSavedNotification"
		static let LogoutResponseDataDidGetSaved = "LogoutResponseDataDidGetSavedNotification"
		static let UserDataDidGetSaved           = "UserDataDidGetSavedNotification"
	}

	// MARK: - Private Stored Variables

	private var _account:       UdacityAccount? = nil
	private var _loginSession:  UdacitySession? = nil
	private var _logoutSession: UdacitySession? = nil
	private var _user:          UdacityUser?    = nil
	
	// MARK: - internal Computed Variables

	internal var account: UdacityAccount? {
		return _account
	}

	internal var isLoginSuccessful: Bool {
		return ((_account != nil) && (_loginSession != nil))
	}

	internal var isLogoutSuccessful: Bool {
		return (_logoutSession != nil)
	}

	internal var loginData: (UdacityAccount?, UdacitySession?) {
		get { return (_account, _loginSession) }

		set(data) {
			_account      = data.0
			_loginSession = data.1
			notifCtr.postNotificationName(Notification.LoginResponseDataDidGetSaved, object: nil)
		}
	}

	internal var logoutData: (UdacitySession) {
		get { return _logoutSession! }

		set(data) {
			_logoutSession = data
			notifCtr.postNotificationName(Notification.LogoutResponseDataDidGetSaved, object: nil)
		}
	}
	
	internal var user: UdacityUser? {
		get { return _user }

		set(newUser) {
			_user = newUser
			notifCtr.postNotificationName(Notification.UserDataDidGetSaved, object: nil)
		}
	}
	
	// MARK: - Private Computed Variables

	private var notifCtr: NSNotificationCenter{
		return NSNotificationCenter.defaultCenter()
	}

	// MARK: - Private

	override private init() {
		super.init()
	}
	
}

