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
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var logoutButton:  UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
//    private let locationManager = CLLocationManager()
    
    // MARK: - IB Actions
    
    @IBAction func didTapBarButtonItem(_ barButtonItem: UIBarButtonItem) {
        
        switch barButtonItem {
//        case addButton:     print("add button was tapped")
        case logoutButton:  print("logout button was tapped")
        case refreshButton:
            dataMgr.refresh(delegate: self)
            mapView.removeAnnotations(dataMgr.annotations!)
        default:
            assertionFailure("Received event from unknown button")
        }
        
    }
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mapView.removeAnnotations(dataMgr.annotations!)
        dataMgr.refresh(delegate: self)

//        locationManager.delegate = self as? CLLocationManagerDelegate
//        locationManager.requestWhenInUseAuthorization()
//
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter  = kCLDistanceFilterNone
//        locationManager.startUpdatingLocation()
//
//        mapView.showsUserLocation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if dataMgr.areAnnotationsDirty {
            
            DispatchQueue.main.async(execute: {
                self.mapView.addAnnotations(dataMgr.annotations!)
                dataMgr.areAnnotationsDirty = false
            })
            
        }
        
    }
    
}



// MARK: -
// MARK: - Get Locations Workflow Delegate

extension MapController: GetLocationsWorkflowDelegate
{
    func complete() {
        
        DispatchQueue.main.async(execute: {
            self.mapView.addAnnotations(dataMgr.annotations!)
            dataMgr.areAnnotationsDirty = false
        })
        
    }
    
}



// MARK: -
// MARK: - Map View Delegate

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: IB.ReuseID.StudentLocsPinAnnoView) as? MKPinAnnotationView ??
                                MKPinAnnotationView(annotation: annotation, reuseIdentifier: IB.ReuseID.StudentLocsPinAnnoView)
        
//        if let _ = pinAnnotationView {
//            pinAnnotationView!.annotation = annotation
//        } else {
//            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: IB.ReuseID.StudentLocsPinAnnoView)
//        }
        
        pinAnnotationView.animatesDrop              = true
        pinAnnotationView.canShowCallout            = true
        pinAnnotationView.pinTintColor              = MKPinAnnotationView.redPinColor()
        pinAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
//        if annotation.title! == UdacityDataManager.shared.user!.fullName {
//            pinAnnotationView!.pinTintColor = MKPinAnnotationView.greenPinColor()
//        }
        
        return pinAnnotationView
        
    }
    
}
