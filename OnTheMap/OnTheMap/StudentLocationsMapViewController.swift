//
//  StudentLocationsMapViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 12/4/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import MapKit
import UIKit

class StudentLocationsMapViewController: UIViewController, MKMapViewDelegate {

	private var pointAnnotations = [MKPointAnnotation]()

   // MARK: - IB Outlets
   
   @IBOutlet weak var mapView: MKMapView!
   
   // MARK: - View Events
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
		NSNotificationCenter.defaultCenter()
								  .addObserver(self, selector: "studentLocationDidGetPosted:",
				                                     name: StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
															  object: nil)
		NSNotificationCenter.defaultCenter()
			                 .addObserver(self, selector: "studentLocationsDidGetRefreshed:",
				                                     name: StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
				                                   object: nil)
		NSNotificationCenter.defaultCenter()
			                 .addObserver(self, selector: "studentLocationDidGetUpdated:",
				                                     name: StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
				                                   object: nil)
  }

   // MARK: - NSNotifications

	func studentLocationDidGetPosted(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
				 "unknown notification = \(notification)")

		pointAnnotations.append(StudentLocationsManager.sharedMgr.postedLocation.pointAnnotation)
		mapView.addAnnotation(StudentLocationsManager.sharedMgr.postedLocation.pointAnnotation)
   }
   
	func studentLocationsDidGetRefreshed(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
			    "unknown notification = \(notification)")

		mapView.removeAnnotations(pointAnnotations)
		pointAnnotations.removeAll()

      for index in 0...(StudentLocationsManager.sharedMgr.count - 1) {
         pointAnnotations.append(StudentLocationsManager.sharedMgr.studentLocationAtIndex(index).pointAnnotation)
      }
      
      mapView.addAnnotations(pointAnnotations)
   }
   
	func studentLocationDidGetUpdated(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
			    "unknown notification = \(notification)")

		let indexOfUpdate = notification.userInfo![StudentLocationsManager.Notifications.IndexOfUpdatedStudentLocationKey] as! Int

		mapView.removeAnnotation(pointAnnotations[indexOfUpdate])
		mapView.addAnnotation(StudentLocationsManager.sharedMgr.studentLocationAtIndex(indexOfUpdate).pointAnnotation)

		pointAnnotations[indexOfUpdate] = StudentLocationsManager.sharedMgr.studentLocationAtIndex(indexOfUpdate).pointAnnotation
	}

   // MARK: - MKMapViewDelegate
   
   func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      
      if control == view.rightCalloutAccessoryView {
         var validURL = false
         
         if let URL = NSURL(string: (view.annotation?.subtitle!)!) {
            validURL = UIApplication.sharedApplication().openURL(URL)
         }
         
         if !validURL {
				presentAlert(Constants.Alert.Title.BadBrowser, message: Constants.Alert.Message.BadURL)
         }

      }
      
   }

   func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
      var pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.UI.ReuseID.StudentLocationsPinAnnotationView) as? MKPinAnnotationView
      
      if let _ = pinAnnotationView {
         pinAnnotationView!.annotation = annotation
      } else {
         pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.UI.ReuseID.StudentLocationsPinAnnotationView)
         pinAnnotationView!.canShowCallout = true
         pinAnnotationView!.pinTintColor = MKPinAnnotationView.redPinColor()
         pinAnnotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
      }
      
      return pinAnnotationView
   }
   
}
