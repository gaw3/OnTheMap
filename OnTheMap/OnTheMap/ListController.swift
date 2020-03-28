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
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - IB Actions
    
    @IBAction func didTapBarButtonItem(_ barButtonItem: UIBarButtonItem) {
        
        switch barButtonItem {
        case refreshButton: dataMgr.refreshCannedLocations()
        default:            assertionFailure("Received event from unknown button")
        }
        
    }
    
    // MARK: - Variables
    
    private enum SectionType {
        case addedLocations
        case cannedLocations
        
        var title: String {
            switch self {
            case .addedLocations:  return "Added Locations"
            case .cannedLocations: return "Canned Locations"
            }
        }
        
    }
    
    private struct ListSection {
        let type:         SectionType
        let numberOfRows: Int
    }
    
    private var sections = [ListSection]()
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sections.removeAll()
        
        if dataMgr.addedLocations.count > 0 {
            self.sections.append(ListSection(type: .addedLocations, numberOfRows: dataMgr.addedLocations.count))
        }
        
        self.sections.append(ListSection(type: .cannedLocations, numberOfRows: dataMgr.cannedLocations.locations.count))

        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .newCannedLocationsAvailable,
                                                       object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .newAddedLocationsAvailable,
                                                       object: nil)
    }
    
}



// MARK: -
// MARK: - Notifications

extension ListController {
    
    @objc func process(notification: Notification) {
        
        DispatchQueue.main.async(execute: {

            switch notification.name {
            
            case .newCannedLocationsAvailable:
                self.tableView.reloadData()

            case .newAddedLocationsAvailable:
                self.sections.removeAll()
                
                if dataMgr.addedLocations.count > 0 {
                    self.sections.append(ListSection(type: .addedLocations, numberOfRows: dataMgr.addedLocations.count))
                }
                
                self.sections.append(ListSection(type: .cannedLocations, numberOfRows: dataMgr.cannedLocations.locations.count))
                
                self.tableView.reloadData()

                
            default: assertionFailure("Received unknown notification = \(notification)")
            }
            
        })
        
    }
    
}



// MARK: -
// MARK: - Table View Data Source

extension ListController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.ReuseID.listCell) ??
                   UITableViewCell(style: .subtitle, reuseIdentifier: String.ReuseID.listCell)
        
        switch sections[indexPath.section].type {
            
        case .cannedLocations:
            let location = dataMgr.cannedLocations.locations[indexPath.row]
            
            cell.textLabel?.text       = "\(location.firstName ?? "NFM") \(location.lastName ?? "NLM") (\(location.mapString ?? "No Mapstring"))"
            cell.detailTextLabel?.text = location.mediaURL ?? "No URL"

            return cell

        case .addedLocations:
            let annotation = dataMgr.addedLocations.getLocation(at: indexPath.row)
            
            cell.textLabel?.text       = "\(annotation.firstName) \(annotation.lastName) (\(annotation.placemark.name ?? "Hell"))"
            cell.detailTextLabel?.text = annotation.url

            return cell
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].type.title
    }
    
}



// MARK: -
// MARK: - Table View Delegate

extension ListController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            goToWebsite(withURLString: cell.detailTextLabel!.text!)
        }

    }

}
