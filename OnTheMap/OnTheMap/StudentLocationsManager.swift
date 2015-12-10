//
//  StudentLocationsManager.swift
//  OnTheMap
//
//  Created by Gregory White on 12/7/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

let StudentLocationsDidGetRefreshedNotification = "StudentLocationsDidGetRefreshedNotification"

private let _sharedMgr = StudentLocationsManager()

class StudentLocationsManager: NSObject {

	// MARK: - Public Variables

	class var sharedMgr: StudentLocationsManager {
		return _sharedMgr
	}

	// MARK: - Private Variables

	private var studentLocations: [StudentLocation]

	// MARK: - Public API

	func count() -> Int {
		return studentLocations.count
	}

	func refreshStudentLocations() {
		ParseAPIClient.sharedClient.getStudentLocations(refreshStudentLocationsCompletionHandler)
	}

	func studentLocationAtIndexPath(indexPath: NSIndexPath) -> StudentLocation {
		return studentLocations[indexPath.row]
	}

	// MARK: - Private Completion Handlers

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
				
				self.postNotification(StudentLocationsDidGetRefreshedNotification)
			}

		}

	}

	// MARK: - Private

	private override init() {
		studentLocations = [StudentLocation]()
		super.init()
	}

	private func postNotification(name: String) {
		NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
	}

}
