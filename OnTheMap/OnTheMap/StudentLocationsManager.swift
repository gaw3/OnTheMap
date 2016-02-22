//
//  StudentLocationsManager.swift
//  OnTheMap
//
//  Created by Gregory White on 12/7/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import UIKit

private let _sharedMgr = StudentLocationsManager()

final internal class StudentLocationsManager: NSObject {

	class internal var sharedMgr: StudentLocationsManager {
		return _sharedMgr
	}

	// MARK: - Internal Constants

	internal struct Notifications {
		static let StudentLocationDidGetPosted      = "StudentLocationDidGetPostedNotification"
		static let StudentLocationsDidGetRefreshed  = "StudentLocationsDidGetRefreshedNotification"
		static let StudentLocationDidGetUpdated     = "StudentLocationDidGetUpdatedNotification"
		static let IndexOfUpdatedStudentLocationKey = "indexOfUpdate"
	}

	// MARK: - Private Stored Variables

	private var studentLocations: [StudentLocation]

	// MARK: - Internal Computed Variables

	internal var count: Int {
		return studentLocations.count
	}

	internal var postedLocation: StudentLocation {
		get { return studentLocations[0] }

		set (location) {
			studentLocations.insert(location, atIndex: 0)
			notifCtr.postNotificationName(Notifications.StudentLocationDidGetPosted, object: nil)
		}
	}

	// MARK: - Private Computed Variables

	private var notifCtr: NSNotificationCenter{
		return NSNotificationCenter.defaultCenter()
	}
	
	// MARK: - API

	internal func refreshStudentLocations(newStudentLocations: [StudentLocation]) {
		studentLocations.removeAll()
		studentLocations.appendContentsOf(newStudentLocations)

		notifCtr.postNotificationName(Notifications.StudentLocationsDidGetRefreshed, object: nil)
	}

   internal func studentLocationAtIndex(index: Int) -> StudentLocation {
      return studentLocations[index]
   }

	internal func studentLocationAtIndexPath(indexPath: NSIndexPath) -> StudentLocation {
		return studentLocations[indexPath.row]
	}

	internal func updateStudentLocation(studentLocation: StudentLocation) {
		if let indexOfUpdate = studentLocations.indexOf({$0.objectID == studentLocation.objectID}) {
			studentLocations[indexOfUpdate] = studentLocation
			notifCtr.postNotificationName(Notifications.StudentLocationDidGetUpdated, object: nil,
				userInfo: [ Notifications.IndexOfUpdatedStudentLocationKey: indexOfUpdate ])
		} else {
			// how to handle this error case
		}

	}

	// MARK: - Private

	override private init() {
		studentLocations = [StudentLocation]()
		super.init()
	}

}
