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

   // MARK: - Constants
   
   private let StudentLocationsPinAnnotationViewReuseID = "StudentLocationsPinAnnotationView"
   
   // MARK: - IB Outlets
   
   @IBOutlet weak var mapView: MKMapView!
   
   // MARK: - IB Actions
      
	@IBAction func pinButtonWasTapped(sender: UIBarButtonItem) {
		let postInfoVC = storyboard?.instantiateViewControllerWithIdentifier("StudentLocationsPostInformationViewController") as! StudentLocationsPostInformationViewController
		presentViewController(postInfoVC, animated: true, completion: nil)
	}
	
   @IBAction func refreshButtonWasTapped(sender: UIBarButtonItem) {
      StudentLocationsManager.sharedMgr.refreshStudentLocations()
   }

   // MARK: - View Events
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsDidGetRefreshed:",
                                                                 name: StudentLocationsDidGetRefreshedNotification,
                                                               object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationDidGetPosted:",
                                                                 name: StudentLocationDidGetPostedNotification,
                                                               object: nil)
   }
   
   // MARK: - NSNotifications
   
   func studentLocationDidGetPosted(notification: NSNotification) {
      assert(notification.name == StudentLocationDidGetPostedNotification,
         "received unexpected NSNotification, name = \(notification.name)")
   }
   
   func studentLocationsDidGetRefreshed(notification: NSNotification) {
      assert(notification.name == StudentLocationsDidGetRefreshedNotification,
         "received unexpected NSNotification, name = \(notification.name)")
      
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
            let alert = UIAlertController(title: "Unable to open browser", message: "Malformed URL", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
         }

      }
      
   }

   func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
      var pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(StudentLocationsPinAnnotationViewReuseID) as? MKPinAnnotationView
      
      if let _ = pinAnnotationView {
         pinAnnotationView!.annotation = annotation
      } else {
         pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: StudentLocationsPinAnnotationViewReuseID)
         pinAnnotationView!.canShowCallout = true
         pinAnnotationView!.pinTintColor = MKPinAnnotationView.redPinColor()
         pinAnnotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
      }
      
      return pinAnnotationView
   }
   
}
