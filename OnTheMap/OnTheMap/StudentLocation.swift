//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Gregory White on 12/7/15.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

struct StudentLocation {
    
    struct UdacityHQ {
        static let Lat  = Double(37.3999)
        static let Long = Double(-122.108401)
    }
    
    // MARK: - Variables
    
    private var _studentLocation: JSONDictionary
    
    var dateCreated: String {
        get {
            if let date = _studentLocation[ParseAPIClient.API.DateCreatedKey] as! String? { return date }
            return String()
        }
        
        set(date) { _studentLocation[ParseAPIClient.API.DateCreatedKey] = date as AnyObject? }
    }
    
    var dateUpdated: String {
        get {
            if let date = _studentLocation[ParseAPIClient.API.DateUpdatedKey] as! String? { return date }
            return String()
        }
        
        set(date) { _studentLocation[ParseAPIClient.API.DateUpdatedKey] = date as AnyObject? }
    }
    
    var firstName: String {
        get {
            if let name = _studentLocation[ParseAPIClient.API.FirstNameKey] as! String? { return name }
            return String()
        }
        
        set(name) { _studentLocation[ParseAPIClient.API.FirstNameKey] = name as AnyObject? }
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var lastName: String {
        get {
            if let name = _studentLocation[ParseAPIClient.API.LastNameKey] as! String? { return name }
            return String()
        }
        
        set(name) { _studentLocation[ParseAPIClient.API.LastNameKey] = name as AnyObject? }
    }
    
    var latitude: CLLocationDegrees {
        get {
            if let lat = _studentLocation[ParseAPIClient.API.LatKey] as! CLLocationDegrees? { return lat }
            return 0.0
        }
        
        set(lat) { _studentLocation[ParseAPIClient.API.LatKey] = lat as AnyObject? }
    }
    
    var longitude: CLLocationDegrees {
        get {
            if let long = _studentLocation[ParseAPIClient.API.LongKey] as! CLLocationDegrees? { return long }
            return 0.0
        }
        
        set(long) { _studentLocation[ParseAPIClient.API.LongKey] = long as AnyObject? }
    }
    
    var mapString: String {
        get {
            if let str = _studentLocation[ParseAPIClient.API.MapStringKey] as! String? { return str }
            return String()
        }
        
        set(str) { _studentLocation[ParseAPIClient.API.MapStringKey] = str as AnyObject? }
    }
    
    var mediaURL: String {
        get {
            if let stringURL = _studentLocation[ParseAPIClient.API.MediaURLKey] as! String? { return stringURL }
            return String()
        }
        
        set(stringURL) { _studentLocation[ParseAPIClient.API.MediaURLKey] = stringURL as AnyObject? }
    }
    
    var newStudentSerializedData: Data {
        let newStudentDict = [ ParseAPIClient.API.UniqueKeyKey: uniqueKey,
                               ParseAPIClient.API.FirstNameKey: firstName,
                               ParseAPIClient.API.LastNameKey: lastName,
                               ParseAPIClient.API.MapStringKey: mapString,
                               ParseAPIClient.API.MediaURLKey: mediaURL,
                               ParseAPIClient.API.LatKey: latitude,
                               ParseAPIClient.API.LongKey: longitude ] as [String : Any]
        
        let newStudentData = try! JSONSerialization.data(withJSONObject: newStudentDict, options: .prettyPrinted)
        return newStudentData
    }
    
    var objectID: String {
        get {
            if let id = _studentLocation[ParseAPIClient.API.ObjectIDKey] as! String? { return id }
            return String()
        }
        
        set(id) { _studentLocation[ParseAPIClient.API.ObjectIDKey] = id as AnyObject? }
    }
    
    var pointAnnotation: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title      = fullName
        annotation.subtitle   = mediaURL
        
        return annotation
    }
    
    var uniqueKey: String {
        get {
            if let key = _studentLocation[ParseAPIClient.API.UniqueKeyKey] as! String? { return key }
            return String()
        }
        
        set(key) { _studentLocation[ParseAPIClient.API.UniqueKeyKey] = key as AnyObject? }
    }
    

    
    // MARK: - API
    
    init() { _studentLocation = JSONDictionary() }
    
    init(studentLocation: StudentLocation) { _studentLocation = studentLocation._studentLocation }
    
    init(studentLocationDict: JSONDictionary) { _studentLocation = studentLocationDict }
}
