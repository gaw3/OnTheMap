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

	struct Notifications {
		static let StudentLocationDidGetPosted      = "StudentLocationDidGetPostedNotification"
		static let StudentLocationsDidGetRefreshed  = "StudentLocationsDidGetRefreshedNotification"
		static let StudentLocationDidGetUpdated     = "StudentLocationDidGetUpdatedNotification"
		static let IndexOfUpdatedStudentLocationKey = "indexOfUpdate"
	}

	// MARK: - Private Stored Variables

	private var studentLocations: [StudentLocation]

	var count: Int {
		return studentLocations.count
	}

	var postedLocation: StudentLocation {
		get { return studentLocations[0] }

		set (location) {
			studentLocations.insert(location, atIndex: 0)
			NSNotificationCenter.defaultCenter().postNotificationName(Notifications.StudentLocationDidGetPosted, object: nil)
		}
	}

	// MARK: - API

	func refreshStudentLocations(newStudentLocations: [StudentLocation]) {
		studentLocations.removeAll()
		studentLocations.appendContentsOf(newStudentLocations)

		NSNotificationCenter.defaultCenter().postNotificationName(Notifications.StudentLocationsDidGetRefreshed, object: nil)
	}

	func updateStudentLocation(studentLocation: StudentLocation) {
		if let indexOfUpdate = studentLocations.indexOf({$0.objectID == studentLocation.objectID}) {
		   studentLocations[indexOfUpdate] = studentLocation
			NSNotificationCenter.defaultCenter().postNotificationName(Notifications.StudentLocationDidGetUpdated, object: nil,
				                                                       userInfo: [ Notifications.IndexOfUpdatedStudentLocationKey : indexOfUpdate])
		} else {
			// how to handle this error case
		}

	}
   
   func studentLocationAtIndex(index: Int) -> StudentLocation {
      return studentLocations[index]
   }

	func studentLocationAtIndexPath(indexPath: NSIndexPath) -> StudentLocation {
		return studentLocations[indexPath.row]
	}

	// MARK: - Private

	private override init() {
		studentLocations = [StudentLocation]()
		super.init()
	}

}
