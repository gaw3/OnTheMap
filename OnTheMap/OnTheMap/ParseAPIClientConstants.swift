//
//  ParseAPIClientConstants.swift
//  OnTheMap
//
//  Created by Gregory White on 2/3/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

extension ParseAPIClient {
    
    struct API {
        static let BaseURL        = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        static let DateCreatedKey = "createdAt"
        static let DateUpdatedKey = "updatedAt"
        static let FirstNameKey   = "firstName"
        static let LastNameKey    = "lastName"
        static let LatKey		  = "latitude"
        static let MapStringKey   = "mapString"
        static let LongKey		  = "longitude"
        static let MediaURLKey    = "mediaURL"
        static let ObjectIDKey    = "objectId"
        static let ResultsKey     = "results"
        static let UniqueKeyKey   = "uniqueKey"
    }
    
//    struct AppIDField {
//        static let Name  = "X-Parse-Application-Id"
//        static let Value = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
//    }
//    
//    struct RESTAPIKeyField {
//        static let Name  = "X-Parse-REST-API-Key"
//        static let Value = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
//    }
    
}
