//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Gregory White on 12/7/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class StudentLocation: NSObject {

   // MARK: - Public Variables

	var dateCreated: String {

		get {
			if let dateCreated = _dictionary[ParseAPIClient.API.DateCreatedKey] as! String? {
				return dateCreated
			} else {
				return String()
			}
		}

		set(newDateCreated) {
			_dictionary[ParseAPIClient.API.DateCreatedKey] = newDateCreated
		}

	}

	var dateUpdated: String {

		get {
			if let dateUpdated = _dictionary[ParseAPIClient.API.DateUpdatedKey] as! String? {
				return dateUpdated
			} else {
				return String()
			}
		}

		set(newDateUpdated) {
			_dictionary[ParseAPIClient.API.DateUpdatedKey] = newDateUpdated
		}

	}

	var dictionary: JSONDictionary {
		return _dictionary
	}

	var firstName: String {

		get {
			if let firstName = _dictionary[ParseAPIClient.API.FirstNameKey] as! String? {
				return firstName
			} else {
				return String()
			}
		}

		set(newFirstName) {
			_dictionary[ParseAPIClient.API.FirstNameKey] = newFirstName
		}

	}

	var fullName: String {
		return "\(firstName) \(lastName)"
	}

	var lastName: String {

		get {
			if let lastName = _dictionary[ParseAPIClient.API.LastNameKey] as! String? {
				return lastName
			} else {
				return String()
			}
		}

		set(newLastName) {
			_dictionary[ParseAPIClient.API.LastNameKey] = newLastName
		}

	}

	var latitude: Double? {

		get {
			if let latitude = _dictionary[ParseAPIClient.API.LatKey] as! Double? {
				return latitude
			} else {
				return nil
			}
		}

		set(newLatitude) {
			_dictionary[ParseAPIClient.API.LatKey] = newLatitude
		}

	}

	var mapString: String {

		get {
			if let mapString = _dictionary[ParseAPIClient.API.MapStringKey] as! String? {
				return mapString
			} else {
				return String()
			}
		}

		set(newMapString) {
			_dictionary[ParseAPIClient.API.MapStringKey] = newMapString
		}

	}

	var longitude: Double? {

		get {
			if let longitude = _dictionary[ParseAPIClient.API.LongKey] as! Double? {
				return longitude
			} else {
				return nil
			}
		}

		set(newLongitude) {
			_dictionary[ParseAPIClient.API.LongKey] = newLongitude
		}

	}

	var mediaURL: String {

		get {
			if let mediaURL = _dictionary[ParseAPIClient.API.MediaURLKey] as! String? {
				return mediaURL
			} else {
				return String()
			}
		}

		set(newMediaURL) {
			_dictionary[ParseAPIClient.API.MediaURLKey] = newMediaURL
		}

	}

	var objectID: String {

		get {
			if let objectID = _dictionary[ParseAPIClient.API.ObjectIDKey] as! String? {
				return objectID
			} else {
				return String()
			}
		}

		set(newObjectID) {
			_dictionary[ParseAPIClient.API.ObjectIDKey] = newObjectID
		}

	}
	
	var uniqueKey: String {

		get {
			if let uniqueKey = _dictionary[ParseAPIClient.API.UniqueKeyKey] as! String? {
				return uniqueKey
			} else {
				return String()
			}
		}

		set(newUniqueKey) {
			_dictionary[ParseAPIClient.API.UniqueKeyKey] = newUniqueKey
		}

	}

	// MARK: - Private Variables

	private var _dictionary: JSONDictionary

	// MARK: - Public API

	override init() {
      _dictionary = JSONDictionary()
	}

	init(dictionary: JSONDictionary) {
		self._dictionary = dictionary
		super.init()
	}

}
