//
//  StudentLocationsMapViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 12/4/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import MapKit
import UIKit

final internal class StudentLocationsMapViewController: UIViewController {
    
    // MARK: - Internal Constants
    
    internal struct StudentLocsPinAnnoView {
        static let ReuseID = "StudentLocsPinAnnoView"
    }
    
    // MARK: - Private Stored Variables
    
    fileprivate var pointAnnotations = [MKPointAnnotation]()
    
    // MARK: - IB Outlets
    
    @IBOutlet weak internal var mapView: MKMapView!
    
    // MARK: - View Events
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationObservers()
    }
    
    // MARK: - MKMapViewDelegate
    
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            openSystemBrowserWithURL((view.annotation!.subtitle!)!)
        }
        
    }
    
    internal func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: StudentLocsPinAnnoView.ReuseID) as? MKPinAnnotationView
        
        if let _ = pinAnnotationView {
            pinAnnotationView!.annotation = annotation
        } else {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: StudentLocsPinAnnoView.ReuseID)
        }
        
        pinAnnotationView!.canShowCallout            = true
        pinAnnotationView!.pinTintColor              = MKPinAnnotationView.redPinColor()
        pinAnnotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        if annotation.title! == udacityDataMgr.user!.fullName {
            pinAnnotationView!.pinTintColor = MKPinAnnotationView.greenPinColor()
        }
        
        return pinAnnotationView
    }
    
}

// MARK: - Notifications

extension StudentLocationsMapViewController {
    
    func processNotification(_ notification: Notification) {
        
        switch notification.name {
            
        case NotificationName.StudentLocationDidGetPosted:
            pointAnnotations.append(slMgr.postedLocation.pointAnnotation)
            mapView.addAnnotation(slMgr.postedLocation.pointAnnotation)
            
        case NotificationName.StudentLocationsDidGetRefreshed:
            mapView.removeAnnotations(pointAnnotations)
            pointAnnotations.removeAll()
            
            for index in 0...(slMgr.count - 1) {
                pointAnnotations.append(slMgr.studentLocationAtIndex(index).pointAnnotation)
            }
            
            mapView.addAnnotations(pointAnnotations)
            
        case NotificationName.StudentLocationDidGetUpdated:
            let indexOfUpdate = notification.userInfo![StudentLocationsManager.Notifications.IndexOfUpdatedStudentLocationKey] as! Int
            
            mapView.removeAnnotation(pointAnnotations[indexOfUpdate])
            mapView.addAnnotation(slMgr.studentLocationAtIndex(indexOfUpdate).pointAnnotation)
            
            pointAnnotations[indexOfUpdate] = slMgr.studentLocationAtIndex(indexOfUpdate).pointAnnotation
            
            
        default: fatalError("Received unknown notification = \(notification)")
        }
        
    }
    
}

private extension StudentLocationsMapViewController {
    
    struct SEL {
        static let ProcessNotification = #selector(processNotification(_:))
    }
    
    func addNotificationObservers() {
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.StudentLocationDidGetPosted,     object: nil)
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.StudentLocationsDidGetRefreshed, object: nil)
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.StudentLocationDidGetUpdated,    object: nil)
    }
    
}
