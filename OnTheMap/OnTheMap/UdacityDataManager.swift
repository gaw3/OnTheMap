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

	var account: UdacityAccount? {
		get { return _account }
	}

	var loginData: (UdacityAccount?, UdacitySession?) {
		get { return (_account, _session) }

		set(newData) {
			_account = newData.0
			_session = newData.1
			NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.LoginResponseDataDidGetSaved, object: nil)
		}
	}

	var isLoginSuccessful: Bool {
		get {  return ((_account != nil) && (session != nil)) }
	}

	var isLogoutSuccessful: Bool {
		get { return true }
	}

	var session: UdacitySession? {
		get { return _session }
	}
	
	var user: UdacityUser? {
		get { return _user }

		set(newUser) {
			_user = newUser
			NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.UserDataDidGetSaved, object: nil)
		}
	}
	
	// MARK: - Private Stored Variables

	private var _account: UdacityAccount? = nil
	private var _session: UdacitySession? = nil
	private var _user:    UdacityUser?    = nil

	// MARK: - Private

	private override init() {
		super.init()
	}
	
}

