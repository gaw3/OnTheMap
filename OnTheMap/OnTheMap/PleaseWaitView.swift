//
//  PleaseWaitView.swift
//  OnTheMap
//
//  Created by Gregory White on 1/29/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import UIKit

final class PleaseWaitView: NSObject {

	// MARK: - Private Constants

	private struct Consts {
		static let NoAlpha: CGFloat		 = 0.0
		static let ActivityAlpha: CGFloat = 0.7
	}

	// MARK: - Private Stored Variables

	private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
	private var _dimmedView: UIView? = nil

	// MARK: - Public Computed Variables

	var dimmedView: UIView {
		return _dimmedView!
	}
	
	// MARK: - API

	init(requestingView: UIView) {
		super.init()

		_dimmedView = UIView(frame: requestingView.frame)
		_dimmedView?.backgroundColor = UIColor.blackColor()
		_dimmedView?.alpha           = Consts.NoAlpha

		activityIndicator.center    = _dimmedView!.center
		activityIndicator.center.y *= 1.5
		activityIndicator.hidesWhenStopped = true

		_dimmedView?.addSubview(activityIndicator)
	}

	func startActivityIndicator() {
		_dimmedView?.alpha = Consts.ActivityAlpha
		activityIndicator.startAnimating()
	}

	func stopActivityIndicator() {
		activityIndicator.stopAnimating()
		_dimmedView?.alpha = Consts.NoAlpha
	}

	// MARK: - Private

	private override init() {
		super.init()
	}

}
