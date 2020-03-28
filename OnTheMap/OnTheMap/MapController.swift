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
    
    @IBOutlet weak var annotationStyleButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton:         UIBarButtonItem!
    
    // MARK: - IB Actions
    
    @IBAction func didTapBarButtonItem(_ barButtonItem: UIBarButtonItem) {
        
        switch barButtonItem {
            
        case refreshButton:         dataMgr.refreshCannedLocations()
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
    
    private var locationManager: CLLocationManager? = nil
    private var annotationStyle  = AnnotationStyle.marker
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .newCannedLocationsAvailable,
                                                       object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .newAddedLocationsAvailable,
                                                       object: nil)

        mapType.configure()
        mapView.addAnnotations(dataMgr.cannedLocations.newAnnos)
        mapView.showsUserLocation = false

        locationManager = CLLocationManager()
        locationManager?.delegate        = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter  = kCLDistanceFilterNone
        
        if CLLocationManager.locationServicesEnabled() {
           checkLocationAuthorization()
        } else {
           assertionFailure("Received unknown location auth status")
        }

    }
    
}



// MARK: -
// MARK: - Notifications

extension MapController {
    
    @objc func process(notification: Notification) {
        
        DispatchQueue.main.async(execute: {

            switch notification.name {
            
            case .newCannedLocationsAvailable:
                self.mapView.removeAnnotations(dataMgr.cannedLocations.oldAnnos)
                self.mapView.addAnnotations(dataMgr.cannedLocations.newAnnos)
                
            case .newAddedLocationsAvailable:
                if let anno = dataMgr.addedLocations.newest {
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

extension MapController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #warning("take care of this error handling")
        let clError = error as! CLError
        print("\(clError)")

        if clError.code == .denied {
            locationManager = nil
            print("location services denied by the user")
        }
        
    }
    
}



// MARK: -
// MARK: - Map View Delegate

extension MapController: MKMapViewDelegate {
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if type(of: annotation) == MKUserLocation.self {
            print("skipping user location annotation")
            return nil
        }
        
        if annotationStyle == .marker {
            let marker = mapView.dequeueReusableAnnotationView(withIdentifier: String.ReuseID.annotationView) as? MKMarkerAnnotationView ??
                         MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: String.ReuseID.annotationView)
            
            (annotation as! AnnotationViewable).configure(annotationView: marker)
            return marker
        } else {
            let pin = mapView.dequeueReusableAnnotationView(withIdentifier: String.ReuseID.annotationView) as? MKPinAnnotationView ??
                         MKPinAnnotationView(annotation: annotation, reuseIdentifier: String.ReuseID.annotationView)
            
            (annotation as! AnnotationViewable).configure(annotationView: pin)
            return pin
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            print("accessory control tapped")
            goToWebsite(withURLString: view.annotation!.subtitle!!)
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
        
        #warning("put this in a enum")
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
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            print("auth status = authorizedWhenInUse")
            locationManager?.startUpdatingLocation()
            mapView.showsUserLocation = true
            
        case .denied: // Show alert telling users how to turn on permissions
            print("auth status = denied")
//            mapView.showsUserLocation = false
            break
            
        case .notDetermined:
            print("auth status = notDetermined")
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
            mapView.showsUserLocation = true
            
        case .restricted: // Show an alert letting them know what’s up
            print("auth status = restricted")
            break
            
        case .authorizedAlways:
            print("auth status = authorizedAlways")
            break
            
        @unknown default:
            assertionFailure("Received unknown location auth status")
        }
        
    }
    
}
