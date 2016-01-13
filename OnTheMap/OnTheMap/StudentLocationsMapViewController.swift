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

   // MARK: - IB Outlets
   
   @IBOutlet weak var mapView: MKMapView!
   
   // MARK: - IB Actions
      
	@IBAction func pinButtonWasTapped(sender: UIBarButtonItem) {
		let postInfoVC = storyboard?.instantiateViewControllerWithIdentifier(Constants.UI.StoryboardID.StudentLocationsPostInformationVC)
							  as! StudentLocationsPostInformationViewController
		presentViewController(postInfoVC, animated: true, completion: nil)
	}
	
   @IBAction func refreshButtonWasTapped(sender: UIBarButtonItem) {
      StudentLocationsManager.sharedMgr.refreshStudentLocations()
   }

   // MARK: - View Events
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationDidGetPosted:",
																					  name: Constants.Notification.StudentLocationDidGetPosted,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsDidGetRefreshed:",
																					  name: Constants.Notification.StudentLocationsDidGetRefreshed,
																					object: nil)
		
		StudentLocationsManager.sharedMgr.refreshStudentLocations()
  }

   // MARK: - NSNotifications

	func studentLocationDidGetPosted(notification: NSNotification) {
		assert(notification.name == Constants.Notification.StudentLocationDidGetPosted, "unknown notification = \(notification)")
   }
   
	func studentLocationsDidGetRefreshed(notification: NSNotification) {
		assert(notification.name == Constants.Notification.StudentLocationsDidGetRefreshed, "unknown notification = \(notification)")

      var pointAnnotations = [MKPointAnnotation]()
      
      for index in 0...(StudentLocationsManager.sharedMgr.count() - 1) {
         pointAnnotations.append(StudentLocationsManager.sharedMgr.studentLocationAtIndex(index).pointAnnotation)
      }
      
      mapView.addAnnotations(pointAnnotations)
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
