//
//  CannedLocationAnnotation.swift
//  OnTheMap
//
//  Created by Gregory White on 3/20/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import MapKit

class CannedLocationAnnotation: MKPointAnnotation {
    
    // MARK: - Initializers

    init(location: Locations.Location) {
        super.init()
        
        coordinate = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        title      = "\(location.firstName ?? "NFN") \(location.lastName ?? "NLN")"
        subtitle   = "\(location.mediaURL!)"
    }
    
}



// MARK: -
// MARK: - Annotation Viewable

extension CannedLocationAnnotation: AnnotationViewable {
    
    func configure(annotationView view: MKMarkerAnnotationView) {
        view.canShowCallout    = true
        view.animatesWhenAdded = true
        view.markerTintColor   = .red
        view.glyphText         = "🥫"
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.clusteringIdentifier      = "ClusterID"
    }

    func configure(annotationView view: MKPinAnnotationView) {
        view.canShowCallout = true
        view.animatesDrop   = true
        view.pinTintColor   = .red
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.clusteringIdentifier      = "ClusterID"
    }
    
}
