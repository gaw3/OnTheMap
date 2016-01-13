//
//  Constants.swift
//  OnTheMap
//
//  Created by Gregory White on 1/12/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import Foundation

// MARK: - Public Constants

struct Constants {

	struct Alert {

		struct ActionTitle {
			static let OK = "OK"
		}

		struct Message {
			static let BadLoginResponseData  = "Received invalid login response data"
			static let BadLogoutResponseData = "Received invalid logout response data"
			static let BadURL                = "Malformed URL"
			static let BadUserData           = "Received invalid user data"
			static let EmptyPMArray          = "Received an empty placemarks array"
			static let NoLocation            = "Location not yet entered"
			static let NoPMArray             = "Did not receive a placemarks array"
			static let NoURL                 = "Media URL not yet entered"
			static let NoLoginResponseData   = "No login response data received"
			static let NoLogoutResponseData  = "No logout response data received"
			static let NoUserData            = "No user data received"
		}

		struct Title {
			static let BadBrowser = "Unable to open browser"
			static let BadGeocode = "Unable to geocode location"
			static let BadLogin   = "Unable to login"
			static let BadLogout  = "Unable to logout"
			static let BadSubmit  = "Unable to submit location"
		}
		
	}

	struct Notification {
		static let LoginResponseDataDidGetSaved    = "LoginResponseDataDidGetSavedNotification"
		static let LogoutResponseDataDidGetSaved   = "LogoutResponseDataDidGetSavedNotification"
		static let StudentLocationDidGetPosted     = "StudentLocationDidGetPostedNotification"
		static let StudentLocationsDidGetRefreshed = "StudentLocationsDidGetRefreshedNotification"
		static let UserDataDidGetSaved             = "UserDataDidGetSavedNotification"
	}

	struct UI {

		struct ReuseID {
			static let StudentLocationsPinAnnotationView = "StudentLocsPinAnnoView"
			static let StudentLocationsTableViewCell     = "StudentLocsTVCell"
		}

		struct StoryboardID {
			static let StudentLocationsPostInformationVC = "StudentLocsPostInfoVC"
			static let StudentLocationsTabBarController  = "StudentLocsTabBarCtlr"
		}

	}

}

