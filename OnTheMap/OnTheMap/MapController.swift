//
//  MapController.swift
//  OnTheMap
//
//  Created by Gregory White on 3/13/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

final class MapController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var logoutButton:          UIBarButtonItem!
    @IBOutlet weak var annotationStyleButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton:         UIBarButtonItem!
    
//    private let locationManager = CLLocationManager()
    
    // MARK: - IB Actions
    
    @IBAction func didTapBarButtonItem(_ barButtonItem: UIBarButtonItem) {
        
        switch barButtonItem {
        case logoutButton:  print("logout button was tapped")
        case refreshButton: dataMgr.refreshCannedLocations()
        case annotationStyleButton: toggleAnnotationStyle()

        default:
            assertionFailure("Received event from unknown button")
        }
        
    }
    
    @IBAction func valueChanged(_ segControl: UISegmentedControl) {
        
        switch segControl.selectedSegmentIndex {
            
        case 0:  mapView.mapType = .standard
        case 1:  mapView.mapType = .satellite
        case 2:  mapView.mapType = .hybrid
        default: mapView.mapType = .standard
            
        }
        
    }
    
    // MARK: - Variables
    
    private var annotationStyle = AnnotationStyle.marker
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .NewCannedLocationsAvailable,
                                                       object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .NewAddedLocationsAvailable,
                                                       object: nil)

        mapType.configure()
        mapView.addAnnotations(dataMgr.cannedLocations.newAnnos)

//        locationManager.delegate = self as? CLLocationManagerDelegate
//        locationManager.requestWhenInUseAuthorization()
//
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter  = kCLDistanceFilterNone
//        locationManager.startUpdatingLocation()
//
//        mapView.showsUserLocation = true                                                                                                                              
    }
    
}



// MARK: -
// MARK: - Notifications

extension MapController {
    
    @objc func process(notification: Notification) {
        
        DispatchQueue.main.async(execute: {

            switch notification.name {
            
            case .NewCannedLocationsAvailable:
                print("map controller is refreshing")
                self.mapView.removeAnnotations(dataMgr.cannedLocations.oldAnnos)
                self.mapView.addAnnotations(dataMgr.cannedLocations.newAnnos)
                
            case .NewAddedLocationsAvailable:
                if let anno = dataMgr.addedLocations.newest {
                    print("map controller is adding new location")
                    self.mapView.addAnnotation(anno)
                }

            default:
                assertionFailure("Received unknown notification = \(notification)")
            }
            
        })
        
    }
    
}



// MARK: -
// MARK: - Map View Delegate

extension MapController: MKMapViewDelegate {
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotationStyle == .marker {
            let marker = mapView.dequeueReusableAnnotationView(withIdentifier: IB.ReuseID.StudentLocsPinAnnoView) as? MKMarkerAnnotationView ??
                         MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: IB.ReuseID.StudentLocsPinAnnoView)
            
            (annotation as! AnnotationViewable).configure(annotationView: marker)
            return marker
        } else {
            let pin = mapView.dequeueReusableAnnotationView(withIdentifier: IB.ReuseID.StudentLocsPinAnnoView) as? MKPinAnnotationView ??
                         MKPinAnnotationView(annotation: annotation, reuseIdentifier: IB.ReuseID.StudentLocsPinAnnoView)
            
            (annotation as! AnnotationViewable).configure(annotationView: pin)
            return pin
        }
        
    }
    
}



// MARK: -
// MARK: - Private Helpers

private extension MapController {
    
    enum AnnotationStyle {
        case pin
        case marker
    }
    
    func toggleAnnotationStyle() {
        
        if annotationStyle == .marker {
            annotationStyle = .pin
            annotationStyleButton.image = UIImage(named: "MapMarker")
        } else {
            annotationStyle = .marker
            annotationStyleButton.image = UIImage(named: "MapPin")

        }

        mapView.removeAnnotations(dataMgr.cannedLocations.newAnnos)
        mapView.removeAnnotations(dataMgr.addedLocations.annos)
        mapView.addAnnotations(dataMgr.cannedLocations.newAnnos)
        mapView.addAnnotations(dataMgr.addedLocations.annos)

    }
    
}
