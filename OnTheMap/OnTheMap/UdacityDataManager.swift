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

	// MARK: - Private Stored Variables

	fileprivate var _account:       UdacityAccount? = nil
	fileprivate var _loginSession:  UdacitySession? = nil
	fileprivate var _logoutSession: UdacitySession? = nil
	fileprivate var _user:          UdacityUser?    = nil
	
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
			NotificationCenter.default.post(name: NotificationName.UdacityLoginResponseDataDidGetSaved, object: nil)
		}
	}

	internal var logoutData: (UdacitySession) {
		get { return _logoutSession! }

		set(data) {
			_logoutSession = data
			NotificationCenter.default.post(name: NotificationName.UdacityLogoutResponseDataDidGetSaved, object: nil)
		}
	}
	
	internal var user: UdacityUser? {
		get { return _user }

		set(newUser) {
			_user = newUser
			NotificationCenter.default.post(name: NotificationName.UdacityUserDataDidGetSaved, object: nil)
		}
	}
	
	// MARK: - Private

	override fileprivate init() {
		super.init()
	}
	
}

