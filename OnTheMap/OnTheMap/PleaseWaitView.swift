//
//  PleaseWaitView.swift
//  OnTheMap
//
//  Created by Gregory White on 1/29/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

final class PleaseWaitView {
    
    // MARK: - Constants
    
    fileprivate struct Consts {
        static let NoAlpha       = CGFloat(0.0)
        static let ActivityAlpha = CGFloat(0.7)
    }
    
    // MARK: - Variables
    
    fileprivate let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate var _dimmedView: UIView? = nil
    
    var dimmedView: UIView { return _dimmedView! }
    
    // MARK: - API
    
    init(requestingView: UIView) {
        _dimmedView = UIView(frame: requestingView.frame)
        _dimmedView?.backgroundColor = UIColor.black
        _dimmedView?.alpha           = Consts.NoAlpha
        
        activityIndicator.center    = _dimmedView!.center
        activityIndicator.center.y *= 1.5
        activityIndicator.hidesWhenStopped = true
        
        _dimmedView?.addSubview(activityIndicator)
    }
    
}



// MARK: -
// MARK: - API

extension PleaseWaitView {

    func startActivityIndicator() {
        
        DispatchQueue.main.async(execute:  {
            self._dimmedView?.alpha = Consts.ActivityAlpha
            self.activityIndicator.startAnimating()
        })
        
    }
    
    func stopActivityIndicator() {
        
        DispatchQueue.main.async(execute:  {
            self.activityIndicator.stopAnimating()
            self._dimmedView?.alpha = Consts.NoAlpha
        })
        
    }
}
