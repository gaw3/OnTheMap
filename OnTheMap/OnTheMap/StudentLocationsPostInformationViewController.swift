//
//  StudentLocationsPostInformationViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 1/7/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class StudentLocationsPostInformationViewController: UIViewController, MKMapViewDelegate,
																	  UITextFieldDelegate {

	// MARK: - Constants

	private let FindButtonTitle      = "Find On The Map"
	private let SubmitButtonTitle    = "Submit"
	private let LocationInstructions = "Enter Location Here"
	private let MediaURLInstructions = "Enter Media URL Here"

	private let NoLocationAlertMsg   = "Location not yet entered"
	private let NoURLAlertMsg        = "Media URL not yet entered"
	private let NoPMArrayAlertMsg    = "Did not receive a placemarks array"
	private let EmptyPMArrayAlertMsg = "Received an empty placemarks array"

	private let BadGeocodeAlertTitle = "Unable to geocode location"
	private let OKAlertTitle         = "OK"
	private let BadSubmitAlertTitle  = "Unable to submit location"

	// MARK: - IB Outlets

	@IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var toolbarButton: UIBarButtonItem!
	@IBOutlet weak var mediaURLTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!

	// MARK: - IB Actions

	@IBAction func toolbarButtonWasTapped(sender: UIBarButtonItem) {

		if sender.title == FindButtonTitle {
			findOnTheMap()
		} else if sender.title == SubmitButtonTitle {
			submit()
		}

	}

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		imageView.hidden = false

		locationTextField.hidden = false
		locationTextField.text   = LocationInstructions

		mediaURLTextField.hidden = true
		mediaURLTextField.text   = MediaURLInstructions

		mapView.hidden	= true

		toolbarButton.title = FindButtonTitle
	}
	
	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		assert(textField == mediaURLTextField || textField == locationTextField,
				 "received notification from unexpected UITextField")

		textField.resignFirstResponder()

		if textField.text == ""  {
			textField.text = (textField == locationTextField) ? LocationInstructions : MediaURLInstructions
		}

		return true
	}
	
	// MARK: - Private:  Completion Handlers

	private var geocodeCompletionHandler : CLGeocodeCompletionHandler {

		return { (placemarks, error) -> Void in

			guard error == nil else {

				dispatch_async(dispatch_get_main_queue(), {
					self.presentAlert(self.BadGeocodeAlertTitle, message: error!.localizedDescription)
				})

				return
			}

			guard placemarks != nil else {

				dispatch_async(dispatch_get_main_queue(), {
					self.presentAlert(self.BadGeocodeAlertTitle, message: self.NoPMArrayAlertMsg)
				})

				return
			}

			guard placemarks!.count > 0 else {

				dispatch_async(dispatch_get_main_queue(), {
					self.presentAlert(self.BadGeocodeAlertTitle, message: self.EmptyPMArrayAlertMsg)
				})

				return
			}

			let studentLocationPlacemark = placemarks![0] as CLPlacemark
			var deltaDegrees: CLLocationDegrees

			if let _ = studentLocationPlacemark.thoroughfare {
				deltaDegrees = 0.2
			} else if let _ = studentLocationPlacemark.locality {
				deltaDegrees = 0.5
			} else {
				deltaDegrees = 12.0
			}

			let studentLocationAnnotation = MKPointAnnotation()
			studentLocationAnnotation.coordinate = (studentLocationPlacemark.location?.coordinate)!

			let studentLocationRegion = MKCoordinateRegion(center: (studentLocationPlacemark.location?.coordinate)!,
																			 span: MKCoordinateSpanMake(deltaDegrees, deltaDegrees))

			dispatch_async(dispatch_get_main_queue(), {
            self.transitionToMapAndURL(studentLocationAnnotation, region: studentLocationRegion)
			})

		}

	}

	// MARK: - Private:  UI

	private func findOnTheMap() {

		if locationTextField.text == LocationInstructions {
			presentAlert(BadGeocodeAlertTitle, message: NoLocationAlertMsg)
		} else {
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(locationTextField.text!, completionHandler: geocodeCompletionHandler)
		}

	}

	private func presentAlert(title: String, message: String) {
		let alert  = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: OKAlertTitle, style: .Default, handler: nil)
		alert.addAction(action)
		presentViewController(alert, animated: true, completion: nil)
	}

	private func submit() {

		if mediaURLTextField.text == MediaURLInstructions {
			presentAlert(BadSubmitAlertTitle, message: NoURLAlertMsg)
		} else {
			print("media URL = \(mediaURLTextField.text)")
		}
		
	}

	private func transitionToMapAndURL(annotation: MKPointAnnotation, region: MKCoordinateRegion) {
		view.backgroundColor = imageView.backgroundColor

		imageView.hidden         = true
		locationTextField.hidden = true

		mediaURLTextField.hidden = false

		mapView.hidden = false
		mapView.addAnnotation(annotation)
		mapView.setRegion(region, animated: true)
		mapView.regionThatFits(region)

		toolbarButton.title = SubmitButtonTitle
	}

}
