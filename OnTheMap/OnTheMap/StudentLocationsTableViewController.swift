//
//  StudentLocationsTableViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 12/4/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation
import UIKit

final  class StudentLocationsTableViewController: UITableViewController {
    
    // MARK: - View Management
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationObservers()
    }
    
}



// MARK: -
// MARK: - Notifications

extension StudentLocationsTableViewController {
    
    func processNotification(_ notification: Notification) {
        
        switch notification.name {
            
        case Notifications.StudentLocationDidGetPosted:     tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        case Notifications.StudentLocationsDidGetRefreshed: tableView.reloadData()
            
        case Notifications.StudentLocationDidGetUpdated:
            let indexOfUpdate = notification.userInfo![Notifications.IndexOfUpdatedStudentLocationKey] as! Int
            tableView.reloadRows(at: [IndexPath(row: indexOfUpdate, section: 0)], with: .fade)
            
        default: fatalError("Received unknown notification = \(notification)")
        }
        
    }
    
}



// MARK: - Table View Data Source

extension StudentLocationsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        assert(tableView == self.tableView, "Unexpected table view requesting number of sections in table view")
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(tableView == self.tableView, "Unexpected table view requesting cell for row at index path")
        
        let studentLocation = StudentLocationsManager.shared.studentLocation(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: IB.ReuseID.StudentLocsTVCell, for: indexPath)
        
        cell.textLabel?.text       = studentLocation.fullName + "  (\(studentLocation.mapString))"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(tableView == self.tableView, "Unexpected table view requesting number of rows in section")
        
        return StudentLocationsManager.shared.count
    }
    
}



// MARK: - Table View Delegate

extension StudentLocationsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assert(tableView == self.tableView, "Unexpected table view selected a row")
        
        tableView.deselectRow(at: indexPath, animated: false)
        openSystemBrowserWithURL(StudentLocationsManager.shared.studentLocation(at: indexPath).mediaURL)
    }
    
}



// MARK: - Private Helpers

private extension StudentLocationsTableViewController {
    
    struct SEL {
        static let ProcessNotification = #selector(processNotification(_:))
    }
    
    func addNotificationObservers() {
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.StudentLocationDidGetPosted,     object: nil)
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.StudentLocationsDidGetRefreshed, object: nil)
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: Notifications.StudentLocationDidGetUpdated,    object: nil)
    }
    
}

