//
//  StudentLocationsManager.swift
//  OnTheMap
//
//  Created by Gregory White on 12/7/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

private let _sharedMgr = StudentLocationsManager()

class StudentLocationsManager: NSObject {

	class var sharedMgr: StudentLocationsManager {
		return _sharedMgr
	}

	// MARK: - Private Stored Variables

	private var studentLocations: [StudentLocation]
	private var studentLocationPOSTPending: StudentLocation

	// MARK: - API

	func count() -> Int {
		return studentLocations.count
	}

	func postStudentLocation(studentLocation: StudentLocation) {
		studentLocationPOSTPending = studentLocation
		ParseAPIClient.sharedClient.postStudentLocation(studentLocation.dictionary, completionHandler: postStudentLocationCompletionHandler)
	}

	func refreshStudentLocations() {
		ParseAPIClient.sharedClient.getStudentLocations(refreshStudentLocationsCompletionHandler)
	}
   
   func studentLocationAtIndex(index: Int) -> StudentLocation {
      return studentLocations[index]
   }

	func studentLocationAtIndexPath(indexPath: NSIndexPath) -> StudentLocation {
		return studentLocations[indexPath.row]
	}

	// MARK: - Private:  Completion Handlers as Computed Variables

	private var postStudentLocationCompletionHandler : APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				print("error = \(error)")
				// alert action view to the user that error occurred
				return
			}

			guard result != nil else {
				print("no json data provided to request list completion handler")
				// alert action view again
				return
			}

			let JSONDict = result as! JSONDictionary
			print("\(JSONDict)")

			if let dateCreated = JSONDict[ParseAPIClient.API.DateCreatedKey] as! String? {
				if let objectID = JSONDict[ParseAPIClient.API.ObjectIDKey] as! String? {
					self.studentLocationPOSTPending.dateCreated = dateCreated
					self.studentLocationPOSTPending.dateUpdated = dateCreated
					self.studentLocationPOSTPending.objectID    = objectID

					self.studentLocations.insert(self.studentLocationPOSTPending, atIndex: 0)

					NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.StudentLocationDidGetPosted, object: nil)
				}

			}

		}
		
	}
	
	private var refreshStudentLocationsCompletionHandler : APIDataTaskWithRequestCompletionHandler {

		return { (result, error) -> Void in

			guard error == nil else {
				print("error = \(error)")
				// alert action view to the user that error occurred
				return
			}

			guard result != nil else {
				print("no json data provided to request list completion handler")
				// alert action view again
				return
			}

			let JSONDict = result as! JSONDictionary
			print("\(JSONDict)")

			if let dictArray = JSONDict[ParseAPIClient.API.ResultsKey] as! [JSONDictionary]? {
				self.studentLocations.removeAll()

				for dict: JSONDictionary in dictArray
				{
					let studentLocation = StudentLocation(dictionary: dict)
					self.studentLocations.append(studentLocation)
				}
				
				NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.StudentLocationsDidGetRefreshed, object: nil)
			}

		}

	}

	// MARK: - Private

	private override init() {
		studentLocations           = [StudentLocation]()
		studentLocationPOSTPending = StudentLocation()
		super.init()
	}

}
