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

typealias NewStudent = (firstName: String, lastName: String, udacityUserID: String)

class StudentLocationsPostInformationViewController: UIViewController, MKMapViewDelegate,
																	  UITextFieldDelegate {

	// MARK: - Private Constants

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

	// MARK: - IB Outlets

	var currentStudentLocation: StudentLocation? {
		get { return _currentStudentLocation }

		set(location) {
			_currentStudentLocation = location
			_newStudent = nil
		}
	}

	var newStudent: NewStudent? {
		get { return _newStudent }

		set(student) {
			_currentStudentLocation = nil
			_newStudent = student
		}
	}

	private var _currentStudentLocation: StudentLocation? = nil
	private var _newStudent: NewStudent? = nil

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

		imageView.hidden         = false
		locationTextField.hidden = false
		mediaURLTextField.hidden = true
		mapView.hidden	          = true
		toolbarButton.title      = ButtonTitle.Find

		if let _ = currentStudentLocation {
			// updating
			locationTextField.text = currentStudentLocation?.mapString
			mediaURLTextField.text = currentStudentLocation?.mediaURL
			// don't clear on edit
			// cursor at end of string
		} else {
			// posting
			locationTextField.text = InitialText.LocationTextField
			mediaURLTextField.text = InitialText.MediaURLTextField
		}

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

			dispatch_async(dispatch_get_main_queue(), {
				NetworkActivityIndicatorManager.sharedManager.endActivity()
			})

			guard error == nil else {
				self.presentAlert(Constants.Alert.Title.BadGeocode, message: error!.localizedDescription)
				return
			}

			guard placemarks != nil else {
				self.presentAlert(Constants.Alert.Title.BadGeocode, message: Constants.Alert.Message.NoPMArray)
				return
			}

			guard placemarks!.count > 0 else {
				self.presentAlert(Constants.Alert.Title.BadGeocode, message: Constants.Alert.Message.EmptyPMArray)
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

			self.transitionToMapAndURL(studentLocationAnnotation, region: studentLocationRegion)
		}

	}

	// MARK: - Private:  UI Helpers

	private func findOnTheMap() {

		if locationTextField.text == InitialText.LocationTextField {
			presentAlert(Constants.Alert.Title.BadGeocode, message: Constants.Alert.Message.NoLocation)
		} else {
			let geocoder = CLGeocoder()
			NetworkActivityIndicatorManager.sharedManager.startActivity();
			geocoder.geocodeAddressString(locationTextField.text!, completionHandler: geocodeCompletionHandler)
		}

	}

	private func submit() {

		if mediaURLTextField.text == InitialText.MediaURLTextField {
			presentAlert(Constants.Alert.Title.BadSubmit, message: Constants.Alert.Message.NoURL)
		} else {
			print("media URL = \(mediaURLTextField.text)")
		}
		
	}

	private func transitionToMapAndURL(annotation: MKPointAnnotation, region: MKCoordinateRegion) {

		dispatch_async(dispatch_get_main_queue(), {
			self.view.backgroundColor = self.imageView.backgroundColor

			self.imageView.hidden         = true
			self.locationTextField.hidden = true

			self.mediaURLTextField.hidden = false

			self.mapView.hidden = false
			self.mapView.addAnnotation(annotation)
			self.mapView.setRegion(region, animated: true)
			self.mapView.regionThatFits(region)

			self.toolbarButton.title = ButtonTitle.Submit
		})

	}

}
