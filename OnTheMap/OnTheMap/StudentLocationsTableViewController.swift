//
//  StudentLocationsTableViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 12/4/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: UITableViewController {

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter()
								  .addObserver(self, selector: "studentLocationDidGetPosted:",
																 name: StudentLocationsManager.Notifications.StudentLocationDidGetPosted,
															  object: nil)
		NSNotificationCenter.defaultCenter()
								  .addObserver(self, selector: "studentLocationsDidGetRefreshed:",
																 name: StudentLocationsManager.Notifications.StudentLocationsDidGetRefreshed,
															  object: nil)
		NSNotificationCenter.defaultCenter()
								  .addObserver(self, selector: "studentLocationDidGetUpdated:",
															    name: StudentLocationsManager.Notifications.StudentLocationDidGetUpdated,
				                                   object: nil)
	}

	// MARK: - NSNotifications

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
		let cell = tableView.dequeueReusableCellWithIdentifier(Constants.UI.ReuseID.StudentLocationsTableViewCell, forIndexPath: indexPath)

		cell.textLabel?.text       = studentLocation.fullName
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
      
      let studentLocation = StudentLocationsManager.sharedMgr.studentLocationAtIndexPath(indexPath)
      var validURL = false
      
      if let URL = NSURL(string: studentLocation.mediaURL) {
         validURL = UIApplication.sharedApplication().openURL(URL)
      }
      
      if !validURL {
         tableView.deselectRowAtIndexPath(indexPath, animated: false)
			presentAlert(Constants.Alert.Title.BadBrowser, message: Constants.Alert.Message.BadURL)
      }

	}
	
}
