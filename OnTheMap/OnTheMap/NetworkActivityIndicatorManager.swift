//
//  NetworkActivityIndicatorManager.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

private let _sharedClient = NetworkActivityIndicatorManager()

final class NetworkActivityIndicatorManager: NSObject {

	class var sharedManager: NetworkActivityIndicatorManager {
		return _sharedClient
	}

	// MARK: - Private Constants

	private let concurrentUpdateQueue = dispatch_queue_create("com.gaw3.OnTheMap.updateQueue", DISPATCH_QUEUE_CONCURRENT)
	private let application           = UIApplication.sharedApplication()

	// MARK: - Private Stored Variables

	private var numOfUpdateTasks = 0

	// MARK: - API

	func completeAllActivities() {

		dispatch_sync(concurrentUpdateQueue, {

			if !self.application.statusBarHidden {
				self.application.networkActivityIndicatorVisible = false
				self.numOfUpdateTasks = 0
			}

		})

	}

	func endActivity() {

		dispatch_sync(concurrentUpdateQueue, {

			if !self.application.statusBarHidden {
				self.numOfUpdateTasks--

				if self.numOfUpdateTasks <= 0 {
					self.application.networkActivityIndicatorVisible = false
					self.numOfUpdateTasks = 0
				}

			}

		})

	}

	func startActivity() {

		dispatch_sync(concurrentUpdateQueue, {

			if !self.application.statusBarHidden {

				if !self.application.networkActivityIndicatorVisible {
					self.application.networkActivityIndicatorVisible = true
					self.numOfUpdateTasks = 0
				}

				self.numOfUpdateTasks++
			}

		})

	}

	// MARK: - Private

	private override init() {
		super.init()
	}

}
