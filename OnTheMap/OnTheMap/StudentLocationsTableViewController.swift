//
//  StudentLocationsTableViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 12/4/15.
//  Copyright © 2015 Gregory White. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: UITableViewController {

	private let StudentLocationsTableViewCellReuseID = "StudentLocationsTableViewCell"
	
	// MARK: - IB Actions

	@IBAction func refreshButtonWasTapped(sender: UIBarButtonItem) {
		StudentLocationsManager.sharedMgr.refreshStudentLocations()
	}
	
	@IBAction func postButtonWasTapped(sender: UIBarButtonItem) {
		let studentLocation = StudentLocation()

		studentLocation.firstName = "Harry"
		studentLocation.lastName  = "Callahan"
		studentLocation.mapString = "Dallas, TX"
		studentLocation.mediaURL  = "https://udacity.com"
		studentLocation.latitude  = 32.7767
		studentLocation.longitude = 96.797
		studentLocation.uniqueKey = "blap"

      StudentLocationsManager.sharedMgr.postStudentLocation(studentLocation)
	}

	// MARK: - View Events

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationsDidGetRefreshed:",
																					  name: StudentLocationsDidGetRefreshedNotification,
																					object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "studentLocationDidGetPosted:",
																					  name: StudentLocationDidGetPostedNotification,
																					object: nil)
	}

	// MARK: - NSNotifications

	func studentLocationDidGetPosted(notification: NSNotification) {
		assert(notification.name == StudentLocationDidGetPostedNotification,
											 "received unexpected NSNotification, name = \(notification.name)")

		tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
	}

	func studentLocationsDidGetRefreshed(notification: NSNotification) {
		assert(notification.name == StudentLocationsDidGetRefreshedNotification,
											 "received unexpected NSNotification, name = \(notification.name)")

		tableView.reloadData()
	}

	// MARK: - UITableViewDataSource

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		assert(tableView == self.tableView, "Unexpected table view requesting number of sections in table view")

		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		assert(tableView == self.tableView, "Unexpected table view requesting cell for row at index path")

		let studentLocation = StudentLocationsManager.sharedMgr.studentLocationAtIndexPath(indexPath)
		let cell = tableView.dequeueReusableCellWithIdentifier(StudentLocationsTableViewCellReuseID, forIndexPath: indexPath)

		cell.textLabel?.text       = studentLocation.fullName
		cell.detailTextLabel?.text = studentLocation.mediaURL

		return cell
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		assert(tableView == self.tableView, "Unexpected table view requesting number of rows in section")

		return StudentLocationsManager.sharedMgr.count()
	}
	
	// MARK: - UITableViewDelegate

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		assert(tableView == self.tableView, "Unexpected table view selected a row")

	}
	
}
