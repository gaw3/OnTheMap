//
//  DataManager.swift
//  OnTheMap
//
//  Created by Gregory White on 3/13/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import Foundation
import MapKit

final class DataManager {
    
    // MARK: - Variables
    
    static let shared = DataManager()
    
    var areAnnotationsDirty: Bool = false
    
    var annotations:          [MKPointAnnotation]?  = nil
    var locations:            Locations?            = nil
    var udacityLoginResponse: UdacityLoginResponse? = nil
    var getLocationsWorkflow: GetLocationsWorkflow? = nil
    
    // MARK: - API
    
    func refresh(delegate: GetLocationsWorkflowDelegate?) {
        getLocationsWorkflow = GetLocationsWorkflow(delegate: delegate)
        getLocationsWorkflow?.get()
    }
    
}
