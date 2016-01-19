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

class StudentLocation: NSObject {

   // MARK: - Public Computed Variables
   
	var dateCreated: String {

		get {
			if let dateCreated = _studentLocation[ParseAPIClient.API.DateCreatedKey] as! String? {
				return dateCreated
			} else {
				return String()
			}
		}

		set(newDateCreated) {
			_studentLocation[ParseAPIClient.API.DateCreatedKey] = newDateCreated
		}

	}

	var dateUpdated: String {

		get {
			if let dateUpdated = _studentLocation[ParseAPIClient.API.DateUpdatedKey] as! String? {
				return dateUpdated
			} else {
				return String()
			}
		}

		set(newDateUpdated) {
			_studentLocation[ParseAPIClient.API.DateUpdatedKey] = newDateUpdated
		}

	}

	var dictionary: JSONDictionary {
		return _studentLocation
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

	var firstName: String {

		get {
			if let firstName = _studentLocation[ParseAPIClient.API.FirstNameKey] as! String? {
				return firstName
			} else {
				return String()
			}
		}

		set(newFirstName) {
			_studentLocation[ParseAPIClient.API.FirstNameKey] = newFirstName
		}

	}

	var fullName: String {
		return "\(firstName) \(lastName)"
	}

	var lastName: String {

		get {
			if let lastName = _studentLocation[ParseAPIClient.API.LastNameKey] as! String? {
				return lastName
			} else {
				return String()
			}
		}

		set(newLastName) {
			_studentLocation[ParseAPIClient.API.LastNameKey] = newLastName
		}

	}

	var latitude: Double {

		get {
         return _studentLocation[ParseAPIClient.API.LatKey] as! Double
		}

		set(newLatitude) {
			_studentLocation[ParseAPIClient.API.LatKey] = newLatitude
		}

	}

	var mapString: String {

		get {
			if let mapString = _studentLocation[ParseAPIClient.API.MapStringKey] as! String? {
				return mapString
			} else {
				return String()
			}
		}

		set(newMapString) {
			_studentLocation[ParseAPIClient.API.MapStringKey] = newMapString
		}

	}

	var longitude: Double {

		get {
         return _studentLocation[ParseAPIClient.API.LongKey] as! Double
		}

		set(newLongitude) {
			_studentLocation[ParseAPIClient.API.LongKey] = newLongitude
		}

	}

	var mediaURL: String {

		get {
			if let mediaURL = _studentLocation[ParseAPIClient.API.MediaURLKey] as! String? {
				return mediaURL
			} else {
				return String()
			}
		}

		set(newMediaURL) {
			_studentLocation[ParseAPIClient.API.MediaURLKey] = newMediaURL
		}

	}

	var objectID: String {

		get {
			if let objectID = _studentLocation[ParseAPIClient.API.ObjectIDKey] as! String? {
				return objectID
			} else {
				return String()
			}
		}

		set(newObjectID) {
			_studentLocation[ParseAPIClient.API.ObjectIDKey] = newObjectID
		}

	}
	
   var pointAnnotation: MKPointAnnotation {
      let annotation = MKPointAnnotation()
      
      annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      annotation.title      = fullName
      annotation.subtitle   = mediaURL
      
      return annotation
   }
   
	var uniqueKey: String {

		get {
			if let uniqueKey = _studentLocation[ParseAPIClient.API.UniqueKeyKey] as! String? {
				return uniqueKey
			} else {
				return String()
			}
		}

		set(newUniqueKey) {
			_studentLocation[ParseAPIClient.API.UniqueKeyKey] = newUniqueKey
		}

	}

	// MARK: - Private Stored Variables

	private var _studentLocation: JSONDictionary

	// MARK: - API

	override init() {
      _studentLocation = JSONDictionary()
		super.init()
	}

	convenience init(studentLocation: StudentLocation) {
		self.init()
		_studentLocation = studentLocation._studentLocation
	}

	convenience init(studentLocationDict: JSONDictionary) {
		self.init()
		_studentLocation = studentLocationDict
	}

}
