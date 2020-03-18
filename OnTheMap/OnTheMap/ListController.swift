//
//  ListController.swift
//  OnTheMap
//
//  Created by Gregory White on 3/13/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import UIKit

final class ListController: UITableViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - IB Actions
    
    @IBAction func didTapBarButtonItem(_ barButtonItem: UIBarButtonItem) {
        
        switch barButtonItem {
        case addButton:     print("add button was tapped")
        case logoutButton:  print("logout button was tapped")
        case refreshButton: dataMgr.refresh(delegate: self)
        default:            assertionFailure("Received event from unknown button")
        }
        
    }
    
}



// MARK: -
// MARK: - Get Locations Workflow Delegate

extension ListController: GetLocationsWorkflowDelegate
{
    func complete() {
        
         DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        
    }
    
}



// MARK: -
// MARK: - Table View Data Source

extension ListController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ListCell")
        }
        
        let location = dataMgr.locations!.results[indexPath.row]
        
        cell?.textLabel?.text       = "\(location.firstName ?? "NFM") \(location.lastName ?? "NLM") (\(location.mapString ?? "No Mapstring"))"
        cell?.detailTextLabel?.text = location.mediaURL ?? "No URL"

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataMgr.locations == nil ? 0 : dataMgr.locations!.results.count
    }
    
}



// MARK: -
// MARK: - Table View Delegate

extension ListController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row at \(indexPath)")
    }

}
