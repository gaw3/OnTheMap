//
//  StudentLocationsTableViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 12/4/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import UIKit

final internal class StudentLocationsTableViewController: UITableViewController {

	// MARK: - Private Constants

	private struct SEL {
		static let DidGetPosted:    Selector = "studentLocationDidGetPosted:"
		static let DidGetRefreshed: Selector = "studentLocationsDidGetRefreshed:"
		static let DidGetUpdated:   Selector = "studentLocationDidGetUpdated:"
	}

	private struct UIConstants {
		static let ReuseID = "StudentLocsTVCell"
	}

	// MARK: - View Events

	override internal func viewDidLoad() {
		super.viewDidLoad()

      addNotificationObservers()
	}

	// MARK: - Notifications

	internal func studentLocationDidGetPosted(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
				 "unknown notification = \(notification)")

		tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
	}

	internal func studentLocationsDidGetRefreshed(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
			    "unknown notification = \(notification)")

		tableView.reloadData()
	}

	internal func studentLocationDidGetUpdated(notification: NSNotification) {
		assert(notification.name == StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
			    "unknown notification = \(notification)")

		let indexOfUpdate = notification.userInfo![StudentLocationsManager.Notifications.IndexOfUpdatedStudentLocationKey] as! Int

      tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexOfUpdate, inSection: 0)], withRowAnimation: .Fade)
	}

	// MARK: - UITableViewDataSource

	override internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		assert(tableView == self.tableView, "Unexpected table view requesting number of sections in table view")

		return 1
	}
	
	override internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		assert(tableView == self.tableView, "Unexpected table view requesting cell for row at index path")

		let studentLocation = slMgr.studentLocationAtIndexPath(indexPath)
		let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.ReuseID, forIndexPath: indexPath)

		cell.textLabel?.text       = studentLocation.fullName + "  (\(studentLocation.mapString))"
		cell.detailTextLabel?.text = studentLocation.mediaURL

		return cell
	}

	override internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		assert(tableView == self.tableView, "Unexpected table view requesting number of rows in section")

		return slMgr.count
	}
	
	// MARK: - UITableViewDelegate

	override internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		assert(tableView == self.tableView, "Unexpected table view selected a row")
      
		tableView.deselectRowAtIndexPath(indexPath, animated: false)
		openSystemBrowserWithURL(slMgr.studentLocationAtIndexPath(indexPath).mediaURL)
	}

	// MARK: - Private

	private func addNotificationObservers() {
		notifCtr.addObserver(self, selector: SEL.DidGetPosted,
												 name: StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
											  object: nil)
		notifCtr.addObserver(self, selector: SEL.DidGetRefreshed,
												 name: StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
											  object: nil)
		notifCtr.addObserver(self, selector: SEL.DidGetUpdated,
											    name: StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
											  object: nil)
	}

}
