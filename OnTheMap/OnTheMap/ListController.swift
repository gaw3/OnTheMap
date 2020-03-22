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
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - IB Actions
    
    @IBAction func didTapBarButtonItem(_ barButtonItem: UIBarButtonItem) {
        
        switch barButtonItem {
        case logoutButton:  print("logout button was tapped")
        case refreshButton: dataMgr.refreshCannedLocations()
        default:            assertionFailure("Received event from unknown button")
        }
        
    }
    
    enum SectionType {
        case addedLocations
        case cannedLocations
    }
    
    struct ListSection {
        let type: SectionType
        let numberOfRows: Int
        let title: String
    }
    
    private var sections = [ListSection]()
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sections.removeAll()
        
        if dataMgr.addedLocations.count > 0 {
            self.sections.append(ListSection(type: .addedLocations, numberOfRows: dataMgr.addedLocations.count, title: "Added Locations"))
        }
        
        self.sections.append(ListSection(type: .cannedLocations, numberOfRows: dataMgr.cannedLocations.locations.count, title: "Canned Locations"))

        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .NewCannedLocationsAvailable,
                                                       object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)),
                                                         name: .NewAddedLocationsAvailable,
                                                       object: nil)
    }
    
}



// MARK: -
// MARK: - Notifications

extension ListController {
    
    @objc func process(notification: Notification) {
        
        DispatchQueue.main.async(execute: {

            switch notification.name {
            
            case .NewCannedLocationsAvailable:
                print("list controller is refreshing")
                self.tableView.reloadData()

            case .NewAddedLocationsAvailable:
                self.sections.removeAll()
                
                if dataMgr.addedLocations.count > 0 {
                    self.sections.append(ListSection(type: .addedLocations, numberOfRows: dataMgr.addedLocations.count, title: "Added Locations"))
                }
                
                self.sections.append(ListSection(type: .cannedLocations, numberOfRows: dataMgr.cannedLocations.locations.count, title: "Canned Locations"))
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") ??
                   UITableViewCell(style: .subtitle, reuseIdentifier: "ListCell")
        
        switch sections[indexPath.section].type {
            
        case .cannedLocations:
            let location = dataMgr.cannedLocations.locations[indexPath.row]
            
            cell.textLabel?.text       = "\(location.firstName ?? "NFM") \(location.lastName ?? "NLM") (\(location.mapString ?? "No Mapstring"))"
            cell.detailTextLabel?.text = location.mediaURL ?? "No URL"

            return cell

        case .addedLocations:
            let annotation = dataMgr.addedLocations.getLocation(at: indexPath.row)
            
            cell.textLabel?.text = "\(annotation.firstName) \(annotation.lastName) (\(annotation.placemark.name ?? "Hell"))"
            cell.detailTextLabel?.text = annotation.url

            return cell
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
}



// MARK: -
// MARK: - Table View Delegate

extension ListController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row at \(indexPath)")
    }

}
