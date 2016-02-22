//
//  StudentLocationsPostInformationViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 1/7/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import UIKit

typealias NewStudent = (firstName: String, lastName: String, udacityUserID: String)

final class StudentLocationsPostInformationViewController: UIViewController {

	// MARK: - Public Constants

	struct UIConstants {
		static let StoryboardID    = "StudentLocsPostInfoVC"
		static let BtnBkndFileName = "WhitePixel"
	}

	// MARK: - Private Constants

	private struct Alert {

		struct Message {
			static let LocationNotEntered = "Location not yet entered"
			static let NoJSONData         = "JSON data unavailable"
			static let NoPlacemarks       = "Did not receive any placemarks"
         static let URLNotEntered      = "Link to share not yet entered"
		}

		struct Title {
			static let BadGeocode = "Unable to geocode location"
			static let BadPost    = "Unable to post new student location"
			static let BadUpdate  = "Unable to update student location"
			static let BadSubmit  = "Unable to submit student location update"
		}

	}

	private struct ButtonTitle {
		static let Find   = "Find On The Map"
		static let Submit = "Submit"
	}

	private struct PlaceholderText {
		static let Attributes    = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		static let LocationField = "Enter Your Location Here"
		static let MediaURLField = "Enter a Link to Share Here"
	}

	// MARK: - Private Stored Variables

	private var _currentStudentLocation: StudentLocation? = nil
	private var _newStudent:				 NewStudent?      = nil
	private var pleaseWaitView:          PleaseWaitView?  = nil

	// MARK: - Public Computed Variables

	var currentStudentLocation: StudentLocation? {
		get { return _currentStudentLocation }

		set(location) {
			_currentStudentLocation = location
		}
	}

	var newStudent: NewStudent? {
		get { return _newStudent }

		set(student) {
			_newStudent = student
		}
	}
	
	// MARK: - IB Outlets

	@IBOutlet      var questionLabels:    [UILabel]!
	@IBOutlet weak var cancelButton:      UIButton!
	@IBOutlet weak var mapView:           MKMapView!
	@IBOutlet weak var imageView:         UIImageView!
	@IBOutlet weak var toolbar:           UIToolbar!
	@IBOutlet weak var toolbarButton:     UIBarButtonItem!
	@IBOutlet weak var mediaURLTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		addSubviews()
		setTextFieldPlaceholders()
		setInitialSubviewVisibility()
		setInitialFieldValues()
		setToolbarButtonBackground()
	}
	
	// MARK: - IB Actions

	@IBAction func cancelButtonWasTapped(sender: UIButton) {
		assert(sender == cancelButton, "rcvd IB Action from unknown button")

		dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func toolbarButtonWasTapped(sender: UIBarButtonItem) {
		assert(sender == toolbarButton, "rcvd IB Action from unknown button")

		if sender.title == ButtonTitle.Find {
			findOnTheMap()
		} else if sender.title == ButtonTitle.Submit {
			submit()
		}

	}

	// MARK: - MKMapViewDelegate

	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		var pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(StudentLocationsMapViewController.StudentLocsPinAnnoView.ReuseID) as? MKPinAnnotationView

		if let _ = pinAnnotationView {
			pinAnnotationView!.annotation = annotation
		} else {
			pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: StudentLocationsMapViewController.StudentLocsPinAnnoView.ReuseID)
			pinAnnotationView!.pinTintColor = MKPinAnnotationView.greenPinColor()
		}

		return pinAnnotationView
	}

	// MARK: - UITextFieldDelegate

	func textFieldShouldReturn(textField: UITextField) -> Bool {
		assert(textField == mediaURLTextField || textField == locationTextField, "unknown UITextField = \(textField)")

		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - Private:  Completion Handlers as Computed Variables

	private var geocodeCompletionHandler: CLGeocodeCompletionHandler {

		return { (placemarks, error) -> Void in

			dispatch_async(dispatch_get_main_queue(), {
				NetworkActivityIndicatorManager.sharedManager.endActivity()
				self.pleaseWaitView!.stopActivityIndicator()
			})

			guard error == nil else {
				self.presentAlert(Alert.Title.BadGeocode, message: error!.localizedDescription)
				return
			}

			guard placemarks != nil else {
				self.presentAlert(Alert.Title.BadGeocode, message: Alert.Message.NoPlacemarks)
				return
			}

			guard placemarks!.count > 0 else {
				self.presentAlert(Alert.Title.BadGeocode, message: Alert.Message.NoPlacemarks)
				return
			}

			let studentLocationPlacemark = placemarks![0] as CLPlacemark

			self.currentStudentLocation?.mapString = self.locationTextField.text!
			self.currentStudentLocation?.latitude  = studentLocationPlacemark.location!.coordinate.latitude
			self.currentStudentLocation?.longitude	= studentLocationPlacemark.location!.coordinate.longitude

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

	private var postStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.presentAlert(Alert.Title.BadPost, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Alert.Title.BadPost, message: Alert.Message.NoJSONData)
				return
			}

			let responseData = ParsePostStudentLocationResponseData(dict: result as! JSONDictionary)

			self.currentStudentLocation!.dateCreated = responseData.dateCreated!
			self.currentStudentLocation!.dateUpdated = responseData.dateCreated!
			self.currentStudentLocation!.objectID    = responseData.id!

			self.dismissViewControllerAnimated(true, completion: {
				self.slMgr.postedLocation = self.currentStudentLocation!
			})

		}
		
	}

	private var updateStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				self.presentAlert(Alert.Title.BadUpdate, message: error!.localizedDescription)
				return
			}

			guard result != nil else {
				self.presentAlert(Alert.Title.BadUpdate, message: Alert.Message.NoJSONData)
				return
			}

			let responseData = ParseUpdateStudentLocationResponseData(dict: result as! JSONDictionary)

			self.currentStudentLocation!.dateUpdated = responseData.dateUpdated!

			self.dismissViewControllerAnimated(true, completion: {
				self.slMgr.updateStudentLocation(self.currentStudentLocation!)
			})

		}

	}

	// MARK: - Private Helpers

	private func addSubviews() {
		questionLabels.forEach({view.addSubview($0)})

		view.addSubview(cancelButton)
		view.addSubview(mapView)
		view.addSubview(imageView)
		view.addSubview(toolbar)
		view.addSubview(mediaURLTextField)
		view.addSubview(locationTextField)
		
		pleaseWaitView = PleaseWaitView(requestingView: view)
		view.addSubview((pleaseWaitView?.dimmedView)!)
		view.bringSubviewToFront((pleaseWaitView?.dimmedView)!)
	}

	private func findOnTheMap() {

		if locationTextField.text!.isEmpty {
			presentAlert(Alert.Title.BadGeocode, message: Alert.Message.LocationNotEntered)
		} else {
			let geocoder = CLGeocoder()
			NetworkActivityIndicatorManager.sharedManager.startActivity();
			pleaseWaitView!.startActivityIndicator()
			geocoder.geocodeAddressString(locationTextField.text!, completionHandler: geocodeCompletionHandler)
		}

	}

	private func setInitialFieldValues() {

		if let _ = newStudent {
			currentStudentLocation = StudentLocation()
			currentStudentLocation?.firstName = newStudent!.firstName
			currentStudentLocation?.lastName  = newStudent!.lastName
			currentStudentLocation?.uniqueKey = newStudent!.udacityUserID
		} else {
			locationTextField.text = currentStudentLocation?.mapString
			mediaURLTextField.text = currentStudentLocation?.mediaURL
			locationTextField.clearsOnBeginEditing = false
			mediaURLTextField.clearsOnBeginEditing = false
		}

	}

	private func setInitialSubviewVisibility() {
		imageView.hidden         = false
		locationTextField.hidden = false
		questionLabels.forEach({$0.hidden = false})

		mediaURLTextField.hidden = true
		mapView.hidden	          = true
	}

	private func setTextFieldPlaceholders() {
		locationTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.LocationField, attributes: PlaceholderText.Attributes)
		mediaURLTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.MediaURLField, attributes: PlaceholderText.Attributes)
	}

	private func setToolbarButtonBackground() {
		let buttonBackground = UIImage(named: UIConstants.BtnBkndFileName)
		buttonBackground?.resizableImageWithCapInsets(UIEdgeInsetsZero)

		toolbarButton.setBackgroundImage(buttonBackground, forState: .Normal, barMetrics: .Default)
		toolbarButton.title = ButtonTitle.Find
	}
	
	private func submit() {

		if mediaURLTextField.text!.isEmpty {
			presentAlert(Alert.Title.BadSubmit, message: Alert.Message.URLNotEntered)
		} else {
			currentStudentLocation?.mediaURL = mediaURLTextField.text!

			if let _ = newStudent {
				parseClient.postStudentLocation(currentStudentLocation!, completionHandler: postStudentLocationCompletionHandler)
			} else {
				parseClient.updateStudentLocation(currentStudentLocation!, completionHandler: updateStudentLocationCompletionHandler)
			}

		}

	}
	
	private func transitionToMapAndURL(annotation: MKPointAnnotation, region: MKCoordinateRegion) {
		view.backgroundColor = imageView.backgroundColor
		toolbarButton.title  = ButtonTitle.Submit
		toolbar.backgroundColor = UIColor.clearColor()
		toolbar.translucent = true
		cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

		mapView.addAnnotation(annotation)
		mapView.setRegion(region, animated: true)
		mapView.regionThatFits(region)
		mapView.hidden = false

		imageView.hidden         = true
		locationTextField.hidden = true
		mediaURLTextField.hidden = false
		questionLabels.forEach({$0.hidden = true})
	}

}
