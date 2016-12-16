//
//  NetworkActivityIndicatorManager.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

private let _shared = NetworkActivityIndicatorManager()

final class NetworkActivityIndicatorManager {
    
    class var shared: NetworkActivityIndicatorManager {
        return _shared
    }
    
    // MARK: - Constants
    
    private struct QName {
        static let NAIUpdateQueue = "com.gaw3.OnTheMap.NetworkActivityIndicatorUpdateQueue"
    }
    
    // MARK: - Variables
    
    private var numOfUpdateTasks      = 0
    private let concurrentUpdateQueue = DispatchQueue(label: QName.NAIUpdateQueue, attributes: DispatchQueue.Attributes.concurrent)
    
    // MARK: - API
    
    func completeAllActivities() {
        
        concurrentUpdateQueue.sync(execute: {
            
            if !UIApplication.shared.isStatusBarHidden {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.numOfUpdateTasks = 0
            }
            
        })
        
    }
    
    func endActivity() {
        
        concurrentUpdateQueue.sync(execute: {
            
            if !UIApplication.shared.isStatusBarHidden {
                self.numOfUpdateTasks -= 1
                
                if self.numOfUpdateTasks <= 0 {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.numOfUpdateTasks = 0
                }
                
            }
            
        })
        
    }
    
    func startActivity() {
        
        concurrentUpdateQueue.sync(execute: {
            
            if !UIApplication.shared.isStatusBarHidden {
                
                if !UIApplication.shared.isNetworkActivityIndicatorVisible {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    self.numOfUpdateTasks = 0
                }
                
                self.numOfUpdateTasks += 1
            }
            
        })
        
    }
    
}
