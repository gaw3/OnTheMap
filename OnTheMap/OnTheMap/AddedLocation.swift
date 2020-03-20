//
//  AddedLocation.swift
//  OnTheMap
//
//  Created by Gregory White on 3/19/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import Foundation
import MapKit

struct AddedLocation {
    
    // MARK: - Variables

    var annotation:   MKPointAnnotation
    var deltaDegrees: CLLocationDegrees
    var placemark:    CLPlacemark
    var region:       MKCoordinateRegion

    var firstName: String
    var lastName:  String
    var url:       String

    // MARK: - Initializers

    init(placemark: CLPlacemark, firstName: String, lastName: String, url: String) {
        self.placemark = placemark
        self.firstName = firstName
        self.lastName  = lastName
        self.url       = url
        
        if let _ = placemark.thoroughfare {
            deltaDegrees = 0.2
        } else if let _ = placemark.locality {
            deltaDegrees = 0.5
        } else {
            deltaDegrees = 12.0
        }
        
        annotation = MKPointAnnotation()
        annotation.coordinate = placemark.location!.coordinate
        annotation.title      = "\(firstName) \(lastName)"
        annotation.subtitle   = "\(url)"

        let span = MKCoordinateSpan(latitudeDelta: deltaDegrees, longitudeDelta: deltaDegrees)
        
        region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
    }
    
}



// MARK: -
// MARK: - Annotation Viewable

extension AddedLocation: AnnotationViewable {
    
    func configure(annotationView view: MKPinAnnotationView) {
        
    }
    
    func configure(annotationView view: MKMarkerAnnotationView) {
        view.canShowCallout    = true
        view.animatesWhenAdded = true
        view.markerTintColor   = .blue
        view.glyphText         = "👨‍🎓"
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }

}
