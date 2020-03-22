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
    
    var udacityLoginResponse: UdacityLoginResponse? = nil
    var getLocationsWorkflow = GetLocationsWorkflow()
    var addedLocations       = AddedLocations()
    var cannedLocations      = CannedLocations()
    
    // MARK: - API
    
    func refreshCannedLocations() {
        getLocationsWorkflow.get()
    }
    
}

class AddedLocations {
    private var annotations = [AddedLocationAnnotation]()
    
    func add(annotation: AddedLocationAnnotation) {
        annotations.append(annotation)
        NotificationCenter.default.post(name: .NewAddedLocationsAvailable, object: nil)
    }
    
    var newest: AddedLocationAnnotation? {
        return annotations.last
    }
    
}


class CannedLocations {
    
    private var newAnnotations = [CannedLocationAnnotation]()
    private var oldAnnotations = [CannedLocationAnnotation]()
    private var _locations     = [Locations.Location]()
    
    func put(newLocations: Locations) {
        _locations = newLocations.results
        
        oldAnnotations.removeAll()
        
        for annotation in newAnnotations {
            oldAnnotations.append(annotation)
        }
        
        newAnnotations.removeAll()

        for location in _locations {
            newAnnotations.append(CannedLocationAnnotation(location: location))
        }

        NotificationCenter.default.post(name: .NewCannedLocationsAvailable, object: nil)
    }
    
    var locations: [Locations.Location] {
        return _locations
    }
    
    var newAnnos: [CannedLocationAnnotation] {
        return newAnnotations
    }
    
    var oldAnnos: [CannedLocationAnnotation] {
        return oldAnnotations
    }

}
