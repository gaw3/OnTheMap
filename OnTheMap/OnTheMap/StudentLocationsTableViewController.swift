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
    
    // MARK: - Private Constants
    
    fileprivate struct UIConstants {
        static let ReuseID = "StudentLocsTVCell"
    }
    
    // MARK: - View Events
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationObservers()
    }
    
    // MARK: - UITableViewDataSource
    
    override  func numberOfSections(in tableView: UITableView) -> Int {
        assert(tableView == self.tableView, "Unexpected table view requesting number of sections in table view")
        
        return 1
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assert(tableView == self.tableView, "Unexpected table view requesting cell for row at index path")
        
        let studentLocation = slMgr.studentLocationAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: UIConstants.ReuseID, for: indexPath)
        
        cell.textLabel?.text       = studentLocation.fullName + "  (\(studentLocation.mapString))"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(tableView == self.tableView, "Unexpected table view requesting number of rows in section")
        
        return slMgr.count
    }
    
    // MARK: - UITableViewDelegate
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assert(tableView == self.tableView, "Unexpected table view selected a row")
        
        tableView.deselectRow(at: indexPath, animated: false)
        openSystemBrowserWithURL(slMgr.studentLocationAtIndexPath(indexPath).mediaURL)
    }
    
}

// MARK: - Notifications

extension StudentLocationsTableViewController {
    
    func processNotification(_ notification: Notification) {
        
        switch notification.name {
            
        case NotificationName.StudentLocationDidGetPosted:
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            
            
        case NotificationName.StudentLocationsDidGetRefreshed:
            tableView.reloadData()
            
            
        case NotificationName.StudentLocationDidGetUpdated:
            let indexOfUpdate = notification.userInfo![StudentLocationsManager.Notifications.IndexOfUpdatedStudentLocationKey] as! Int
            
            tableView.reloadRows(at: [IndexPath(row: indexOfUpdate, section: 0)], with: .fade)
            
            
        default: fatalError("Received unknown notification = \(notification)")
        }
        
    }
    
}

private extension StudentLocationsTableViewController {
    
    struct SEL {
        static let ProcessNotification = #selector(processNotification(_:))
    }
    
    func addNotificationObservers() {
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.StudentLocationDidGetPosted,     object: nil)
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.StudentLocationsDidGetRefreshed, object: nil)
        notifCtr.addObserver(self, selector: SEL.ProcessNotification, name: NotificationName.StudentLocationDidGetUpdated,    object: nil)
    }
    
}

