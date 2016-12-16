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

final internal class StudentLocationsPostInformationViewController: UIViewController {

	// MARK: - Internal  Constants

	internal struct UIConstants {
		static let StoryboardID    = "StudentLocsPostInfoVC"
		static let BtnBkndFileName = "WhitePixel"
	}

	// MARK: - Private Constants

	fileprivate struct Alert {

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

	fileprivate struct ButtonTitle {
		static let Find   = "Find On The Map"
		static let Submit = "Submit"
	}

	fileprivate struct PlaceholderText {
		static let Attributes    = [NSForegroundColorAttributeName: UIColor.white]
		static let LocationField = "Enter Your Location Here"
		static let MediaURLField = "Enter a Link to Share Here"
	}

	// MARK: - Private Stored Variables

	fileprivate var _currentStudentLocation: StudentLocation? = nil
	fileprivate var _newStudent:				 NewStudent?      = nil
	fileprivate var pleaseWaitView:          PleaseWaitView?  = nil

	// MARK: - Internal Computed Variables

	internal var currentStudentLocation: StudentLocation? {
		get { return _currentStudentLocation }

		set(location) {
			_currentStudentLocation = location
		}
	}

	internal var newStudent: NewStudent? {
		get { return _newStudent }

		set(student) {
			_newStudent = student
		}
	}
	
	// MARK: - IB Outlets

	@IBOutlet      internal var questionLabels:    [UILabel]!
	@IBOutlet weak internal var cancelButton:      UIButton!
	@IBOutlet weak internal var mapView:           MKMapView!
	@IBOutlet weak internal var imageView:         UIImageView!
	@IBOutlet weak internal var toolbar:           UIToolbar!
	@IBOutlet weak internal var toolbarButton:     UIBarButtonItem!
	@IBOutlet weak internal var mediaURLTextField: UITextField!
	@IBOutlet weak internal var locationTextField: UITextField!

	// MARK: - View Events

	override internal func viewDidLoad() {
		super.viewDidLoad()

		addSubviews()
		setTextFieldPlaceholders()
		setInitialSubviewVisibility()
		setInitialFieldValues()
		setToolbarButtonBackground()
	}
	
	// MARK: - IB Actions

	@IBAction internal func cancelButtonWasTapped(_ sender: UIButton) {
		assert(sender == cancelButton, "rcvd IB Action from unknown button")

		dismiss(animated: true, completion: nil)
	}

	@IBAction internal func toolbarButtonWasTapped(_ sender: UIBarButtonItem) {
		assert(sender == toolbarButton, "rcvd IB Action from unknown button")

		if sender.title == ButtonTitle.Find {
			findOnTheMap()
		} else if sender.title == ButtonTitle.Submit {
			submit()
		}

	}

	// MARK: - MKMapViewDelegate

	internal func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: StudentLocationsMapViewController.StudentLocsPinAnnoView.ReuseID) as? MKPinAnnotationView

		if let _ = pinAnnotationView {
			pinAnnotationView!.annotation = annotation
		} else {
			pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: StudentLocationsMapViewController.StudentLocsPinAnnoView.ReuseID)
			pinAnnotationView!.pinTintColor = MKPinAnnotationView.greenPinColor()
		}

		return pinAnnotationView
	}

	// MARK: - UITextFieldDelegate

	internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		assert(textField == mediaURLTextField || textField == locationTextField, "unknown UITextField = \(textField)")

		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - Private:  Completion Handlers as Computed Variables

	fileprivate var geocodeCompletionHandler: CLGeocodeCompletionHandler {

		return { (placemarks, error) -> Void in

			DispatchQueue.main.async(execute: {
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

			DispatchQueue.main.async(execute: {
				self.transitionToMapAndURL(studentLocationAnnotation, region: studentLocationRegion)
			})

		}

	}

	fileprivate var postStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {

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

			self.dismiss(animated: true, completion: {
				self.slMgr.postedLocation = self.currentStudentLocation!
			})

		}
		
	}

	fileprivate var updateStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {

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

			self.dismiss(animated: true, completion: {
				self.slMgr.updateStudentLocation(self.currentStudentLocation!)
			})

		}

	}

	// MARK: - Private Helpers

	fileprivate func addSubviews() {
		questionLabels.forEach({view.addSubview($0)})

		view.addSubview(cancelButton)
		view.addSubview(mapView)
		view.addSubview(imageView)
		view.addSubview(toolbar)
		view.addSubview(mediaURLTextField)
		view.addSubview(locationTextField)
		
		pleaseWaitView = PleaseWaitView(requestingView: view)
		view.addSubview((pleaseWaitView?.dimmedView)!)
		view.bringSubview(toFront: (pleaseWaitView?.dimmedView)!)
	}

	fileprivate func findOnTheMap() {

		if locationTextField.text!.isEmpty {
			presentAlert(Alert.Title.BadGeocode, message: Alert.Message.LocationNotEntered)
		} else {
			let geocoder = CLGeocoder()
			NetworkActivityIndicatorManager.sharedManager.startActivity();
			pleaseWaitView!.startActivityIndicator()
			geocoder.geocodeAddressString(locationTextField.text!, completionHandler: geocodeCompletionHandler)
		}

	}

	fileprivate func setInitialFieldValues() {

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

	fileprivate func setInitialSubviewVisibility() {
		imageView.isHidden         = false
		locationTextField.isHidden = false
		questionLabels.forEach({$0.isHidden = false})

		mediaURLTextField.isHidden = true
		mapView.isHidden	          = true
	}

	fileprivate func setTextFieldPlaceholders() {
		locationTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.LocationField, attributes: PlaceholderText.Attributes)
		mediaURLTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.MediaURLField, attributes: PlaceholderText.Attributes)
	}

	fileprivate func setToolbarButtonBackground() {
		let buttonBackground = UIImage(named: UIConstants.BtnBkndFileName)
		buttonBackground?.resizableImage(withCapInsets: UIEdgeInsets.zero)

		toolbarButton.setBackgroundImage(buttonBackground, for: UIControlState(), barMetrics: .default)
		toolbarButton.title = ButtonTitle.Find
	}
	
	fileprivate func submit() {

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
	
	fileprivate func transitionToMapAndURL(_ annotation: MKPointAnnotation, region: MKCoordinateRegion) {
		view.backgroundColor = imageView.backgroundColor
		toolbarButton.title  = ButtonTitle.Submit
		toolbar.backgroundColor = UIColor.clear
		toolbar.isTranslucent = true
		cancelButton.setTitleColor(UIColor.white, for: UIControlState())

		mapView.addAnnotation(annotation)
		mapView.setRegion(region, animated: true)
		mapView.regionThatFits(region)
		mapView.isHidden = false

		imageView.isHidden         = true
		locationTextField.isHidden = true
		mediaURLTextField.isHidden = false
		questionLabels.forEach({$0.isHidden = true})
	}

}
