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

	// MARK: - Private Constants

	private struct AlertMessage {
		static let EmptyPMArray = "Received an empty placemarks array"
		static let NoLocation   = "Location not yet entered"
		static let NoPMArray    = "Did not receive a placemarks array"
		static let NoURL        = "Media URL not yet entered"
	}

	private struct AlertTitle {
		static let BadGeocode = "Unable to geocode location"
		static let BadSubmit  = "Unable to submit location"
		static let OK         = "OK"
	}

	private struct ButtonTitle {
		static let Find   = "Find On The Map"
		static let Submit = "Submit"
	}

	private struct InitialText {
		static let LocationTextField = "Enter Location Here"
		static let MediaURLTextField = "Enter Media URL Here"
	}

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

		if sender.title == ButtonTitle.Find {
			findOnTheMap()
		} else if sender.title == ButtonTitle.Submit {
			submit()
		}

	}

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		imageView.hidden = false

		locationTextField.hidden = false
		locationTextField.text   = InitialText.LocationTextField

		mediaURLTextField.hidden = true
		mediaURLTextField.text   = InitialText.MediaURLTextField

		mapView.hidden	= true

		toolbarButton.title = ButtonTitle.Find
	}
	
	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		assert(textField == mediaURLTextField || textField == locationTextField, "unknown UITextField = \(textField)")

		textField.resignFirstResponder()

		if textField.text!.isEmpty  {
			textField.text = (textField == locationTextField) ? InitialText.LocationTextField : InitialText.MediaURLTextField
		}

		return true
	}
	
	// MARK: - Private:  Completion Handlers as Computed Variables

	private var geocodeCompletionHandler : CLGeocodeCompletionHandler {

		return { (placemarks, error) -> Void in

			guard error == nil else {

				dispatch_async(dispatch_get_main_queue(), {
					self.presentAlert(AlertTitle.BadGeocode, message: error!.localizedDescription)
				})

				return
			}

			guard placemarks != nil else {

				dispatch_async(dispatch_get_main_queue(), {
					self.presentAlert(AlertTitle.BadGeocode, message: AlertMessage.NoPMArray)
				})

				return
			}

			guard placemarks!.count > 0 else {

				dispatch_async(dispatch_get_main_queue(), {
					self.presentAlert(AlertTitle.BadGeocode, message: AlertMessage.EmptyPMArray)
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

	// MARK: - Private:  UI Helpers

	private func findOnTheMap() {

		if locationTextField.text == InitialText.LocationTextField {
			presentAlert(AlertTitle.BadGeocode, message: AlertMessage.NoLocation)
		} else {
			let geocoder = CLGeocoder()
			geocoder.geocodeAddressString(locationTextField.text!, completionHandler: geocodeCompletionHandler)
		}

	}

	private func presentAlert(title: String, message: String) {
		let alert  = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		let action = UIAlertAction(title: AlertTitle.OK, style: .Default, handler: nil)
		alert.addAction(action)
		presentViewController(alert, animated: true, completion: nil)
	}

	private func submit() {

		if mediaURLTextField.text == InitialText.MediaURLTextField {
			presentAlert(AlertTitle.BadSubmit, message: AlertMessage.NoURL)
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

		toolbarButton.title = ButtonTitle.Submit
	}

}
