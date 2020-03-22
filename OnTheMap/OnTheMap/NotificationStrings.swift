//
//  NotificationStrings.swift
//  OnTheMap
//
//  Created by Gregory White on 12/15/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

struct Notifications {
    static let StudentLocationDidGetPosted          = Notification.Name(rawValue: "StudentLocationDidGetPostedNotification")
    static let StudentLocationsDidGetRefreshed      = Notification.Name(rawValue: "StudentLocationsDidGetRefreshedNotification")
    static let StudentLocationDidGetUpdated         = Notification.Name(rawValue: "StudentLocationDidGetUpdatedNotification")
    static let UdacityLoginResponseDataDidGetSaved  = Notification.Name(rawValue: "LoginResponseDataDidGetSavedNotification")
    static let UdacityLogoutResponseDataDidGetSaved = Notification.Name(rawValue: "LogoutResponseDataDidGetSavedNotification")
    static let UdacityUserDataDidGetSaved           = Notification.Name(rawValue: "UserDataDidGetSavedNotification")
    
    static let IndexOfUpdatedStudentLocationKey     = "indexOfUpdate"
    

}


extension Notification.Name {
    static let NewAddedLocationsAvailable  = Notification.Name(rawValue: "NewAddedLocationsAvailable")
    static let NewCannedLocationsAvailable = Notification.Name(rawValue: "NewCannedLocationsAvailable")
}
