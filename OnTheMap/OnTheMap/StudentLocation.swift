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
			if let date = _studentLocation[ParseAPI.DateCreatedKey] as! String? { return date }
			return String()
		}

		set(date) { _studentLocation[ParseAPI.DateCreatedKey] = date }
	}

	var dateUpdated: String {
		get {
			if let date = _studentLocation[ParseAPI.DateUpdatedKey] as! String? { return date }
			return String()
		}

		set(date) { _studentLocation[ParseAPI.DateUpdatedKey] = date }
	}

	var firstName: String {
		get {
			if let name = _studentLocation[ParseAPI.FirstNameKey] as! String? { return name }
			return String()
		}

		set(name) { _studentLocation[ParseAPI.FirstNameKey] = name }
	}

	var lastName: String {
		get {
			if let name = _studentLocation[ParseAPI.LastNameKey] as! String? { return name }
			return String()
		}

		set(name) { _studentLocation[ParseAPI.LastNameKey] = name }
	}

	var latitude: Double {
      get { return _studentLocation[ParseAPI.LatKey] as! Double}
		set(lat) { _studentLocation[ParseAPI.LatKey] = lat }
	}

	var longitude: Double {
		get { return _studentLocation[ParseAPI.LongKey] as! Double }
		set(long) { _studentLocation[ParseAPI.LongKey] = long }
	}

	var mapString: String {
		get {
			if let str = _studentLocation[ParseAPI.MapStringKey] as! String? { return str }
			return String()
		}

		set(str) { _studentLocation[ParseAPI.MapStringKey] = str }
	}
	
	var mediaURL: String {
		get {
			if let stringURL = _studentLocation[ParseAPI.MediaURLKey] as! String? { return stringURL }
			return String()
		}

		set(stringURL) { _studentLocation[ParseAPI.MediaURLKey] = stringURL }
	}

	var objectID: String {
		get {
			if let id = _studentLocation[ParseAPI.ObjectIDKey] as! String? { return id }
				return String()
		}

		set(id) { _studentLocation[ParseAPI.ObjectIDKey] = id }
	}
	
	var uniqueKey: String {
		get {
			if let key = _studentLocation[ParseAPI.UniqueKeyKey] as! String? { return key }
			return String()
		}

		set(key) { _studentLocation[ParseAPI.UniqueKeyKey] = key }
	}

	// MARK: - Public Computed Meta Variables

	var fullName: String {
		get { return "\(firstName) \(lastName)" }
	}

	var newStudentSerializedData: NSData {
		get {
			let newStudentDict = [ ParseAPI.UniqueKeyKey : uniqueKey,
										  ParseAPI.FirstNameKey : firstName,
				                    ParseAPI.LastNameKey  : lastName,
				                    ParseAPI.MapStringKey : mapString,
				                    ParseAPI.MediaURLKey  : mediaURL,
				                    ParseAPI.LatKey       : latitude,
				                    ParseAPI.LongKey      : longitude ]

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
