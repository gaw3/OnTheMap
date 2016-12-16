//
//  StudentLocationsManager.swift
//  OnTheMap
//
//  Created by Gregory White on 12/7/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

private let _shared = StudentLocationsManager()

final class StudentLocationsManager {
    
    class var shared: StudentLocationsManager {
        return _shared
    }
    
    // MARK: - Variables
    
    fileprivate var studentLocations = [StudentLocation]()
    
    var count: Int { return studentLocations.count }
    
    var postedLocation: StudentLocation {
        get { return studentLocations[0] }
        
        set (location) {
            studentLocations.insert(location, at: 0)
            NotificationCenter.default.post(name: Notifications.StudentLocationDidGetPosted, object: nil)
        }
        
    }
    
}



// MARK: - API

extension StudentLocationsManager {
    
    func refresh(studentLocations locations: [StudentLocation]) {
        studentLocations.removeAll()
        studentLocations.append(contentsOf: locations)
        
        NotificationCenter.default.post(name: Notifications.StudentLocationsDidGetRefreshed, object: nil)
    }
    
    func studentLocation(at index: Int) -> StudentLocation {
        return studentLocations[index]
    }
    
    func studentLocation(at indexPath: IndexPath) -> StudentLocation {
        return studentLocations[indexPath.row]
    }
    
    func update(studentLocation location: StudentLocation) {
        
        if let indexOfUpdate = studentLocations.index(where: {$0.objectID == location.objectID}) {
            studentLocations[indexOfUpdate] = location
            NotificationCenter.default.post(name: Notifications.StudentLocationDidGetUpdated, object: nil, userInfo: [ Notifications.IndexOfUpdatedStudentLocationKey: indexOfUpdate ])
        } else {
            // how to handle this error case
        }
        
    }
    
}




