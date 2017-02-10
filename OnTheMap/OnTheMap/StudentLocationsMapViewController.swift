//
//  StudentLocationsMapViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 12/4/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import MapKit
import UIKit

final class StudentLocationsMapViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables
    
    fileprivate var pointAnnotations = [MKPointAnnotation]()
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationObservers()
    }
    
}



// MARK: -
// MARK: - Notifications

extension StudentLocationsMapViewController {
    
    func processNotification(_ notification: Notification) {
        
        switch notification.name {
            
        case Notifications.StudentLocationDidGetPosted:     studentLocationDidGetPosted()
        case Notifications.StudentLocationsDidGetRefreshed: studentLocationsDidGetRefreshed()
        case Notifications.StudentLocationDidGetUpdated:    studentLocationDidGetUpdated(notification)
            
        default: fatalError("Received unknown notification = \(notification)")
        }
        
    }
    
}



// MARK: - Map View Delegate

extension StudentLocationsMapViewController {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            openSystemBrowserWithURL((view.annotation!.subtitle!)!)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: IB.ReuseID.StudentLocsPinAnnoView) as? MKPinAnnotationView
        
        if let _ = pinAnnotationView {
            pinAnnotationView!.annotation = annotation
        } else {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: IB.ReuseID.StudentLocsPinAnnoView)
        }
        
        pinAnnotationView!.canShowCallout            = true
        pinAnnotationView!.pinTintColor              = MKPinAnnotationView.redPinColor()
        pinAnnotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        if annotation.title! == UdacityDataManager.shared.user!.fullName {
            pinAnnotationView!.pinTintColor = MKPinAnnotationView.greenPinColor()
        }
        
        return pinAnnotationView
    }
    
}



// MARK: - Private Helpers

private extension StudentLocationsMapViewController {
    
    struct SEL {
        static let ProcessNotification = #selector(processNotification(_:))
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.StudentLocationDidGetPosted,     object: nil)
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.StudentLocationsDidGetRefreshed, object: nil)
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.StudentLocationDidGetUpdated,    object: nil)
    }
    
    func studentLocationDidGetPosted() {
        pointAnnotations.append(StudentLocationsManager.shared.postedLocation.pointAnnotation)
        mapView.addAnnotation(StudentLocationsManager.shared.postedLocation.pointAnnotation)
    }
    
    func studentLocationDidGetUpdated(_ notification: Notification) {
        let indexOfUpdate = notification.userInfo![Notifications.IndexOfUpdatedStudentLocationKey] as! Int
        
        mapView.removeAnnotation(pointAnnotations[indexOfUpdate])
        mapView.addAnnotation(StudentLocationsManager.shared.studentLocation(at: indexOfUpdate).pointAnnotation)
        
        pointAnnotations[indexOfUpdate] = StudentLocationsManager.shared.studentLocation(at: indexOfUpdate).pointAnnotation
    }

    func studentLocationsDidGetRefreshed() {
        mapView.removeAnnotations(pointAnnotations)
        pointAnnotations.removeAll()
        
        for index in 0...(StudentLocationsManager.shared.count - 1) {
            pointAnnotations.append(StudentLocationsManager.shared.studentLocation(at: index).pointAnnotation)
        }
        
        mapView.addAnnotations(pointAnnotations)
    }
    
}
