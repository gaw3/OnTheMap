//
//  StudentLocationsTableViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 12/4/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: UITableViewController {

	// MARK: - Private Constants

	private struct UIConstants {
		static let ReuseID = "StudentLocsTVCell"
	}

	// MARK: - View Events


	override func viewDidLoad() {
		super.viewDidLoad()

      addNotificationObservers()
	}

	// MARK: - Notifications

	func studentLocationDidGetPosted(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
				 "unknown notification = \(notification)")

		tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
	}

	func studentLocationsDidGetRefreshed(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
			    "unknown notification = \(notification)")

		tableView.reloadData()
	}

	func studentLocationDidGetUpdated(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
			    "unknown notification = \(notification)")

		let indexOfUpdate = notification.userInfo![StudentLocationsManager.Notifications.IndexOfUpdatedStudentLocationKey] as! Int

      tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexOfUpdate, inSection: 0)], withRowAnimation: .Fade)
	}

	// MARK: - UITableViewDataSource

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		assert(tableView == self.tableView, "Unexpected table view requesting number of sections in table view")

		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		assert(tableView == self.tableView, "Unexpected table view requesting cell for row at index path")

		let studentLocation = StudentLocationsManager.sharedMgr.studentLocationAtIndexPath(indexPath)
		let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.ReuseID, forIndexPath: indexPath)

		cell.textLabel?.text       = studentLocation.fullName + "  (\(studentLocation.mapString))"
		cell.detailTextLabel?.text = studentLocation.mediaURL

		return cell
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		assert(tableView == self.tableView, "Unexpected table view requesting number of rows in section")

		return StudentLocationsManager.sharedMgr.count
	}
	
	// MARK: - UITableViewDelegate

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		assert(tableView == self.tableView, "Unexpected table view selected a row")
      
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		openSystemBrowserWithURL(StudentLocationsManager.sharedMgr.studentLocationAtIndexPath(indexPath).mediaURL)
	}

	// MARK: - Private

	private func addNotificationObservers() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationDidGetPosted:",
																				     name: StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsDidGetRefreshed:",
																				     name: StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationDidGetUpdated:",
																				     name: StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
																					object: nil)
	}

}
