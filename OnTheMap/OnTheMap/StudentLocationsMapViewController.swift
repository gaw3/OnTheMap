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

	// MARK: - Private Constants

	private struct SEL {
		static let DidGetPosted:    Selector = "studentLocationDidGetPosted:"
		static let DidGetRefreshed: Selector = "studentLocationsDidGetRefreshed:"
		static let DidGetUpdated:   Selector = "studentLocationDidGetUpdated:"
	}
	
	// MARK: - Private Stored Variables

	private var pointAnnotations = [MKPointAnnotation]()

   // MARK: - IB Outlets
   
   @IBOutlet weak internal var mapView: MKMapView!

   // MARK: - View Events

   override internal func viewDidLoad() {
      super.viewDidLoad()

		addNotificationObservers()
  }

   // MARK: - Notifications

	internal func studentLocationDidGetPosted(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
				 "unknown notification = \(notification)")

		pointAnnotations.append(slMgr.postedLocation.pointAnnotation)
		mapView.addAnnotation(slMgr.postedLocation.pointAnnotation)
   }
   
	internal func studentLocationsDidGetRefreshed(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
			    "unknown notification = \(notification)")

		mapView.removeAnnotations(pointAnnotations)
		pointAnnotations.removeAll()

      for index in 0...(slMgr.count - 1) {
         pointAnnotations.append(slMgr.studentLocationAtIndex(index).pointAnnotation)
      }
      
      mapView.addAnnotations(pointAnnotations)
   }
   
	internal func studentLocationDidGetUpdated(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
			    "unknown notification = \(notification)")

		let indexOfUpdate = notification.userInfo![StudentLocationsManager.Notifications.IndexOfUpdatedStudentLocationKey] as! Int

		mapView.removeAnnotation(pointAnnotations[indexOfUpdate])
		mapView.addAnnotation(slMgr.studentLocationAtIndex(indexOfUpdate).pointAnnotation)

		pointAnnotations[indexOfUpdate] = slMgr.studentLocationAtIndex(indexOfUpdate).pointAnnotation
	}

   // MARK: - MKMapViewDelegate
   
   internal func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      
      if control == view.rightCalloutAccessoryView {
			openSystemBrowserWithURL((view.annotation!.subtitle!)!)
      }
      
   }

   internal func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
      var pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(StudentLocsPinAnnoView.ReuseID) as? MKPinAnnotationView
      
      if let _ = pinAnnotationView {
         pinAnnotationView!.annotation = annotation
      } else {
         pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: StudentLocsPinAnnoView.ReuseID)
         pinAnnotationView!.canShowCallout = true
			pinAnnotationView!.pinTintColor = MKPinAnnotationView.redPinColor()

			if annotation.title! == udacityDataMgr.user!.fullName {
				pinAnnotationView!.pinTintColor = MKPinAnnotationView.greenPinColor()
			}
			
         pinAnnotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
      }
      
      return pinAnnotationView
   }
   
	// MARK: - Private Helpers

	private func addNotificationObservers() {
		notifCtr.addObserver(self, selector: SEL.DidGetPosted,
												 name: StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
											  object: nil)
		notifCtr.addObserver(self, selector: SEL.DidGetRefreshed,
										       name: StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
											  object: nil)
		notifCtr.addObserver(self, selector: SEL.DidGetUpdated,
											    name: StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
											  object: nil)
	}

}
