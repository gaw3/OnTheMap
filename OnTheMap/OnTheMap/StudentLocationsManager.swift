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
        static let IndexOfUpdatedStudentLocationKey = "indexOfUpdate"
    }
    
    // MARK: - Private Stored Variables
    
    fileprivate var studentLocations: [StudentLocation]
    
    // MARK: - Internal Computed Variables
    
    internal var count: Int {
        return studentLocations.count
    }
    
    internal var postedLocation: StudentLocation {
        get { return studentLocations[0] }
        
        set (location) {
            studentLocations.insert(location, at: 0)
            NotificationCenter.default.post(name: NotificationName.StudentLocationDidGetPosted, object: nil)
        }
    }
    
    // MARK: - API
    
    internal func refreshStudentLocations(_ newStudentLocations: [StudentLocation]) {
        studentLocations.removeAll()
        studentLocations.append(contentsOf: newStudentLocations)
        
        NotificationCenter.default.post(name: NotificationName.StudentLocationsDidGetRefreshed, object: nil)
    }
    
    internal func studentLocationAtIndex(_ index: Int) -> StudentLocation {
        return studentLocations[index]
    }
    
    internal func studentLocationAtIndexPath(_ indexPath: IndexPath) -> StudentLocation {
        return studentLocations[indexPath.row]
    }
    
    internal func updateStudentLocation(_ studentLocation: StudentLocation) {
        if let indexOfUpdate = studentLocations.index(where: {$0.objectID == studentLocation.objectID}) {
            studentLocations[indexOfUpdate] = studentLocation
            NotificationCenter.default.post(name: NotificationName.StudentLocationDidGetUpdated, object: nil,
                                            userInfo: [ Notifications.IndexOfUpdatedStudentLocationKey: indexOfUpdate ])
        } else {
            // how to handle this error case
        }
        
    }
    
    // MARK: - Private
    
    override fileprivate init() {
        studentLocations = [StudentLocation]()
        super.init()
    }
    
}


