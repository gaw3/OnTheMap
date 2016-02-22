//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Gregory White on 12/7/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import UIKit

internal struct StudentLocation {

	// MARK: - Private Stored Variables

	private var _studentLocation: JSONDictionary
	
   // MARK: - Internal Computed Variables
   
	internal var dateCreated: String {
		get {
			if let date = _studentLocation[ParseAPIClient.API.DateCreatedKey] as! String? { return date }
			return String()
		}

		set(date) { _studentLocation[ParseAPIClient.API.DateCreatedKey] = date }
	}

	internal var dateUpdated: String {
		get {
			if let date = _studentLocation[ParseAPIClient.API.DateUpdatedKey] as! String? { return date }
			return String()
		}

		set(date) { _studentLocation[ParseAPIClient.API.DateUpdatedKey] = date }
	}

	internal var firstName: String {
		get {
			if let name = _studentLocation[ParseAPIClient.API.FirstNameKey] as! String? { return name }
			return String()
		}

		set(name) { _studentLocation[ParseAPIClient.API.FirstNameKey] = name }
	}

	internal var lastName: String {
		get {
			if let name = _studentLocation[ParseAPIClient.API.LastNameKey] as! String? { return name }
			return String()
		}

		set(name) { _studentLocation[ParseAPIClient.API.LastNameKey] = name }
	}

	internal var latitude: Double {
      get { return _studentLocation[ParseAPIClient.API.LatKey] as! Double}
		set(lat) { _studentLocation[ParseAPIClient.API.LatKey] = lat }
	}

	internal var longitude: Double {
		get { return _studentLocation[ParseAPIClient.API.LongKey] as! Double }
		set(long) { _studentLocation[ParseAPIClient.API.LongKey] = long }
	}

	internal var mapString: String {
		get {
			if let str = _studentLocation[ParseAPIClient.API.MapStringKey] as! String? { return str }
			return String()
		}

		set(str) { _studentLocation[ParseAPIClient.API.MapStringKey] = str }
	}
	
	internal var mediaURL: String {
		get {
			if let stringURL = _studentLocation[ParseAPIClient.API.MediaURLKey] as! String? { return stringURL }
			return String()
		}

		set(stringURL) { _studentLocation[ParseAPIClient.API.MediaURLKey] = stringURL }
	}

	internal var objectID: String {
		get {
			if let id = _studentLocation[ParseAPIClient.API.ObjectIDKey] as! String? { return id }
				return String()
		}

		set(id) { _studentLocation[ParseAPIClient.API.ObjectIDKey] = id }
	}
	
	internal var uniqueKey: String {
		get {
			if let key = _studentLocation[ParseAPIClient.API.UniqueKeyKey] as! String? { return key }
			return String()
		}

		set(key) { _studentLocation[ParseAPIClient.API.UniqueKeyKey] = key }
	}

	// MARK: - Internal Computed Meta Variables

	internal var fullName: String {
		return "\(firstName) \(lastName)"
	}

	internal var newStudentSerializedData: NSData {
		let newStudentDict = [ ParseAPIClient.API.UniqueKeyKey: uniqueKey,
									  ParseAPIClient.API.FirstNameKey: firstName,
									  ParseAPIClient.API.LastNameKey: lastName,
									  ParseAPIClient.API.MapStringKey: mapString,
									  ParseAPIClient.API.MediaURLKey: mediaURL,
									  ParseAPIClient.API.LatKey: latitude,
									  ParseAPIClient.API.LongKey: longitude ]

		let newStudentData = try! NSJSONSerialization.dataWithJSONObject(newStudentDict, options: .PrettyPrinted)
		return newStudentData
	}

	internal var pointAnnotation: MKPointAnnotation {
		let annotation = MKPointAnnotation()

		annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		annotation.title      = fullName
		annotation.subtitle   = mediaURL

		return annotation
	}

	// MARK: - API

	internal init() {
      _studentLocation = JSONDictionary()
	}

	internal init(studentLocation: StudentLocation) {
		_studentLocation = studentLocation._studentLocation
	}

	internal init(studentLocationDict: JSONDictionary) {
		_studentLocation = studentLocationDict
	}

}
