//
//  NewLocationPlacemark.swift
//  OnTheMap
//
//  Created by Gregory White on 3/18/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import CoreLocation
import MapKit

protocol AnnotationViewable {
    func configure(annotationView view: MKPinAnnotationView)
    func configure(annotationView view: MKMarkerAnnotationView)
}

struct CannedLocation: AnnotationViewable {
    
    func configure(annotationView view: MKPinAnnotationView) {
        return
    }
    
    func configure(annotationView view: MKMarkerAnnotationView) {
        return
    }
    
}

