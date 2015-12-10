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

	var dateCreated: String? {
		if let dateCreated = dictionary[ParseAPIClient.API.DateCreatedKey] as! String? {
			return dateCreated
		} else {
			return nil
		}
	}

	var dateUpdated: String? {
		if let dateUpdated = dictionary[ParseAPIClient.API.DateUpdatedKey] as! String? {
			return dateUpdated
		} else {
			return nil
		}
	}

	var firstName: String? {
		if let firstName = dictionary[ParseAPIClient.API.FirstNameKey] as! String? {
			return firstName
		} else {
			return nil
		}
	}

	var fullName: String? {
		return "\(firstName!) \(lastName!)"
	}

	var lastName: String? {
		if let lastName = dictionary[ParseAPIClient.API.LastNameKey] as! String? {
			return lastName
		} else {
			return nil
		}
	}

	var latitude: Double? {
		if let latitude = dictionary[ParseAPIClient.API.LatKey] as! Double? {
			return latitude
		} else {
			return nil
		}
	}

	var location: String? {
		if let location = dictionary[ParseAPIClient.API.LocationKey] as! String? {
			return location
		} else {
			return nil
		}
	}

	var longitude: Double? {
		if let longitude = dictionary[ParseAPIClient.API.LongKey] as! Double? {
			return longitude
		} else {
			return nil
		}
	}

	var mediaURL: String? {
		if let mediaURL = dictionary[ParseAPIClient.API.MediaURLKey] as! String? {
			return mediaURL
		} else {
			return nil
		}
	}

	var uniqueKey: String? {
		if let uniqueKey = dictionary[ParseAPIClient.API.UniqueKeyKey] as! String? {
			return uniqueKey
		} else {
			return nil
		}
	}

	// MARK: - Private Variables

	private var dictionary: JSONDictionary

	// MARK: - Public API

	init(dictionary: JSONDictionary) {
		self.dictionary = dictionary
		super.init()
	}

}
