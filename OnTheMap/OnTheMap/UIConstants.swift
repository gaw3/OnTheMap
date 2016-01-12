//
//  UIConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

// MARK: - Public Constants

struct Notification {
	static let LoginResponseDataDidGetSaved    = "LoginResponseDataDidGetSavedNotification"
	static let StudentLocationDidGetPosted     = "StudentLocationDidGetPostedNotification"
	static let StudentLocationsDidGetRefreshed = "StudentLocationsDidGetRefreshedNotification"
	static let UserDataDidGetSaved             = "UserDataDidGetSavedNotification"
}

struct ReuseID {
	static let StudentLocationsTableViewCell     = "StudentLocsTVCell"
	static let StudentLocationsPinAnnotationView = "StudentLocsPinAnnoView"
}

struct StoryboardID {
	static let StudentLocationsPostInformationVC = "StudentLocsPostInfoVC"
	static let StudentLocationsTabBarController  = "StudentLocsTabBarCtlr"
}

