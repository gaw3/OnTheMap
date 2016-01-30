//
//  PleaseWaitView.swift
//  OnTheMap
//
//  Created by Gregory White on 1/29/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

class PleaseWaitView: NSObject {

	private struct Consts {
		static let NoAlpha: CGFloat		 = 0.0
		static let ActivityAlpha: CGFloat = 0.7
	}

	private var dimmedView: UIView? = nil
	private var activityIndicator: UIActivityIndicatorView? = nil

	init(requestingView: UIView) {
		super.init()

		dimmedView = UIView(frame: requestingView.frame)
		dimmedView?.backgroundColor = UIColor.blackColor()
		dimmedView?.alpha           = Consts.NoAlpha

		requestingView.addSubview(dimmedView!)
		requestingView.bringSubviewToFront(dimmedView!)

		activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
		activityIndicator?.center    = dimmedView!.center
		activityIndicator?.center.y *= 1.5
		activityIndicator?.hidesWhenStopped = true

		dimmedView?.addSubview(activityIndicator!)
	}

	func startActivityIndicator(color: UIColor){
		dimmedView?.alpha = Consts.ActivityAlpha
		activityIndicator?.startAnimating()
	}

	func stopActivityIndicator() {
		activityIndicator?.stopAnimating()
		dimmedView?.alpha = Consts.NoAlpha
	}

	// MARK: - Private

	private override init() {
		super.init()
	}

}
