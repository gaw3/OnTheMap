//
//  GetLocationsWorkflow.swift
//  OnTheMap
//
//  Created by Gregory White on 3/16/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import MapKit
import UIKit

// MARK: -
// MARK: -

protocol GetLocationsWorkflowDelegate: class {
    func complete()
    // processError()
}

// MARK: -
// MARK: -

final class GetLocationsWorkflow: NSObject {
    
    func get() {
        UdacityClient.shared.refreshStudentLocations(completionHandler: processLocations)
    }

}



// MARK: -
// MARK: - Private Completion Handlers

private extension GetLocationsWorkflow {
    
    var processLocations: NetworkTaskCompletionHandler {
        
        return { (result, error) -> Void in
            
            guard error == nil else {
                // TODO: handle this error condition
                print("\(String(describing: error))")
//                var message = String()
//
//                switch error!.code {
//                case LocalizedError.Code.Network: message = Alert.Message.NetworkUnavailable
//                case LocalizedError.Code.HTTP:    message = Alert.Message.HTTPError
//                default:                          message = Alert.Message.BadServerData
//                }
                
//                strongSelf.presentAlert(title: Alert.Title.BadRefresh, message: message)
                return
            }
            
            
            let decoder   = JSONDecoder()
            let locations = try! decoder.decode(Locations.self, from: result as! Data)
            dataMgr.cannedLocations.put(newLocations: locations)
        }
        
    }
    
}
