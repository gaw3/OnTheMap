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
    private weak var delegate: GetLocationsWorkflowDelegate?
    
    init(delegate: GetLocationsWorkflowDelegate?) {
        self.delegate = delegate
    }
    
    func get() {
        ParseAPIClient.shared.refreshStudentLocations(completionHandler: processLocations)
    }

}



// MARK: -
// MARK: - Private Completion Handlers

private extension GetLocationsWorkflow {
    
    var processLocations: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
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
            
            
            let decoder = JSONDecoder()
            
            dataMgr.locations   = try! decoder.decode(Locations.self, from: result as! Data)
            dataMgr.annotations = [MKPointAnnotation]()
            
            for location in dataMgr.locations!.results {
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
                annotation.title      = "\(location.firstName ?? "NFN") \(location.lastName ?? "NLN")"
                annotation.subtitle   = "[\(location.latitude!), \(location.longitude!)]"
                
                dataMgr.annotations!.append(annotation)
            }

            dataMgr.areAnnotationsDirty = true
            
            strongSelf.delegate?.complete()
        }
        
    }

    
}
