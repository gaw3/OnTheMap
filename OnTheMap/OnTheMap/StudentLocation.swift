//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Gregory White on 12/7/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

struct StudentLocation {

	// MARK: - Private Stored Variables

	private var _studentLocation: JSONDictionary
	
   // MARK: - Public Computed Variables
   
	var dateCreated: String {
		get {
			if let date = _studentLocation[ParseAPIClient.API.DateCreatedKey] as! String? { return date }
			return String()
		}

		set(date) { _studentLocation[ParseAPIClient.API.DateCreatedKey] = date }
	}

	var dateUpdated: String {
		get {
			if let date = _studentLocation[ParseAPIClient.API.DateUpdatedKey] as! String? { return date }
			return String()
		}

		set(date) { _studentLocation[ParseAPIClient.API.DateUpdatedKey] = date }
	}

	var firstName: String {
		get {
			if let name = _studentLocation[ParseAPIClient.API.FirstNameKey] as! String? { return name }
			return String()
		}

		set(name) { _studentLocation[ParseAPIClient.API.FirstNameKey] = name }
	}

	var lastName: String {
		get {
			if let name = _studentLocation[ParseAPIClient.API.LastNameKey] as! String? { return name }
			return String()
		}

		set(name) { _studentLocation[ParseAPIClient.API.LastNameKey] = name }
	}

	var latitude: Double {
      get { return _studentLocation[ParseAPIClient.API.LatKey] as! Double}
		set(lat) { _studentLocation[ParseAPIClient.API.LatKey] = lat }
	}

	var longitude: Double {
		get { return _studentLocation[ParseAPIClient.API.LongKey] as! Double }
		set(long) { _studentLocation[ParseAPIClient.API.LongKey] = long }
	}

	var mapString: String {
		get {
			if let str = _studentLocation[ParseAPIClient.API.MapStringKey] as! String? { return str }
			return String()
		}

		set(str) { _studentLocation[ParseAPIClient.API.MapStringKey] = str }
	}
	
	var mediaURL: String {
		get {
			if let stringURL = _studentLocation[ParseAPIClient.API.MediaURLKey] as! String? { return stringURL }
			return String()
		}

		set(stringURL) { _studentLocation[ParseAPIClient.API.MediaURLKey] = stringURL }
	}

	var objectID: String {
		get {
			if let id = _studentLocation[ParseAPIClient.API.ObjectIDKey] as! String? { return id }
				return String()
		}

		set(id) { _studentLocation[ParseAPIClient.API.ObjectIDKey] = id }
	}
	
	var uniqueKey: String {
		get {
			if let key = _studentLocation[ParseAPIClient.API.UniqueKeyKey] as! String? { return key }
			return String()
		}

		set(key) { _studentLocation[ParseAPIClient.API.UniqueKeyKey] = key }
	}

	// MARK: - Public Computed Meta Variables

	var fullName: String {
		get { return "\(firstName) \(lastName)" }
	}

	var newStudentSerializedData: NSData {
		get {
			let newStudentDict = [ ParseAPIClient.API.UniqueKeyKey : uniqueKey,
										  ParseAPIClient.API.FirstNameKey : firstName,
				                    ParseAPIClient.API.LastNameKey  : lastName,
				                    ParseAPIClient.API.MapStringKey : mapString,
				                    ParseAPIClient.API.MediaURLKey  : mediaURL,
				                    ParseAPIClient.API.LatKey       : latitude,
				                    ParseAPIClient.API.LongKey      : longitude ]

			let newStudentData = try! NSJSONSerialization.dataWithJSONObject(newStudentDict, options: .PrettyPrinted)
			return newStudentData
		}
	}

	var pointAnnotation: MKPointAnnotation {
		get {
			let annotation = MKPointAnnotation()

			annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			annotation.title      = fullName
			annotation.subtitle   = mediaURL

			return annotation
		}
	}

	// MARK: - API

	init() {
      _studentLocation = JSONDictionary()
	}

	init(studentLocation: StudentLocation) {
		_studentLocation = studentLocation._studentLocation
	}

	init(studentLocationDict: JSONDictionary) {
		_studentLocation = studentLocationDict
	}

}
