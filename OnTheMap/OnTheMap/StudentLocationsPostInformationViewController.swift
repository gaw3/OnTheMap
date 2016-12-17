//
//  StudentLocationsPostInformationViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 1/7/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

typealias NewStudent = (firstName: String, lastName: String, udacityUserID: String)

final class StudentLocationsPostInformationViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet       var questionLabels:    [UILabel]!
    @IBOutlet weak  var cancelButton:      UIButton!
    @IBOutlet weak  var mapView:           MKMapView!
    @IBOutlet weak  var imageView:         UIImageView!
    @IBOutlet weak  var toolbar:           UIToolbar!
    @IBOutlet weak  var toolbarButton:     UIBarButtonItem!
    @IBOutlet weak  var mediaURLTextField: UITextField!
    @IBOutlet weak  var locationTextField: UITextField!
    
    // MARK: - IB Actions
    
    @IBAction func cancelButtonWasTapped(_ sender: UIButton) {
        assert(sender == cancelButton, "rcvd IB Action from unknown button")
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toolbarButtonWasTapped(_ sender: UIBarButtonItem) {
        assert(sender == toolbarButton, "rcvd IB Action from unknown button")
        
        if sender.title == ButtonTitle.Find {
            findOnTheMap()
        } else if sender.title == ButtonTitle.Submit {
            submit()
        }
        
    }
    
    // MARK: - Variables
    
    var currentStudentLocation: StudentLocation? {
        get { return _currentStudentLocation }
        
        set(location) {
            _currentStudentLocation = location
        }
    }
    
    var newStudent: NewStudent? {
        get { return _newStudent }
        
        set(student) {
            _newStudent = student
        }
    }
    
    fileprivate var _currentStudentLocation: StudentLocation? = nil
    fileprivate var _newStudent:		     NewStudent?      = nil
    fileprivate var pleaseWaitView:          PleaseWaitView?  = nil
    
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setTextFieldPlaceholders()
        setInitialSubviewVisibility()
        setInitialFieldValues()
        setToolbarButtonBackground()
    }
    
}



// MARK: -
// MARK: - Map View Delegate

extension StudentLocationsPostInformationViewController {
    
    func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: IB.ReuseID.StudentLocsPinAnnoView) as? MKPinAnnotationView
        
        if let _ = pinAnnotationView {
            pinAnnotationView!.annotation = annotation
        } else {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: IB.ReuseID.StudentLocsPinAnnoView)
            pinAnnotationView!.pinTintColor = MKPinAnnotationView.greenPinColor()
        }
        
        return pinAnnotationView
    }
    
}



// MARK: - Text Field Delegate

extension StudentLocationsPostInformationViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        assert(textField == mediaURLTextField || textField == locationTextField, "unknown UITextField = \(textField)")
        
        textField.resignFirstResponder()
        return true
    }
    
}



// MARK: - Private Completion Handlers

private extension StudentLocationsPostInformationViewController {
    
    var geocodeCompletionHandler: CLGeocodeCompletionHandler {
        
        return { (placemarks, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                NetworkActivityIndicatorManager.shared.endActivity()
                self.pleaseWaitView!.stopActivityIndicator()
            })
            
            guard error == nil else {
                self.presentAlert(Alert.Title.BadGeocode, message: error!.localizedDescription)
                return
            }
            
            guard placemarks != nil else {
                self.presentAlert(Alert.Title.BadGeocode, message: Alert.Message.NoPlacemarks)
                return
            }
            
            guard placemarks!.count > 0 else {
                self.presentAlert(Alert.Title.BadGeocode, message: Alert.Message.NoPlacemarks)
                return
            }
            
            let studentLocationPlacemark = placemarks![0] as CLPlacemark
            
            self.currentStudentLocation?.mapString = self.locationTextField.text!
            self.currentStudentLocation?.latitude  = studentLocationPlacemark.location!.coordinate.latitude
            self.currentStudentLocation?.longitude	= studentLocationPlacemark.location!.coordinate.longitude
            
            var deltaDegrees: CLLocationDegrees
            
            if let _ = studentLocationPlacemark.thoroughfare {
                deltaDegrees = 0.2
            } else if let _ = studentLocationPlacemark.locality {
                deltaDegrees = 0.5
            } else {
                deltaDegrees = 12.0
            }
            
            let studentLocationAnnotation = MKPointAnnotation()
            studentLocationAnnotation.coordinate = (studentLocationPlacemark.location?.coordinate)!
            
            let studentLocationRegion = MKCoordinateRegion(center: (studentLocationPlacemark.location?.coordinate)!,
                                                           span: MKCoordinateSpanMake(deltaDegrees, deltaDegrees))
            
            DispatchQueue.main.async(execute: {
                self.transitionToMapAndURL(studentLocationAnnotation, region: studentLocationRegion)
            })
            
        }
        
    }
    
    var postStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { (result, error) -> Void in
            
            guard error == nil else {
                self.presentAlert(Alert.Title.BadPost, message: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                self.presentAlert(Alert.Title.BadPost, message: Alert.Message.NoJSONData)
                return
            }
            
            let responseData = ParsePostStudentLocationResponseData(dict: result as! JSONDictionary)
            
            self.currentStudentLocation!.dateCreated = responseData.dateCreated
            self.currentStudentLocation!.dateUpdated = responseData.dateCreated
            self.currentStudentLocation!.objectID    = responseData.id
            
            self.dismiss(animated: true, completion: {
                StudentLocationsManager.shared.postedLocation = self.currentStudentLocation!
            })
            
        }
        
    }
    
    var updateStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { (result, error) -> Void in
            
            guard error == nil else {
                self.presentAlert(Alert.Title.BadUpdate, message: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                self.presentAlert(Alert.Title.BadUpdate, message: Alert.Message.NoJSONData)
                return
            }
            
            let responseData = ParseUpdateStudentLocationResponseData(dict: result as! JSONDictionary)
            
            self.currentStudentLocation!.dateUpdated = responseData.dateUpdated
            
            self.dismiss(animated: true, completion: {
                StudentLocationsManager.shared.update(studentLocation: self.currentStudentLocation!)
            })
            
        }
        
    }
    
}



// MARK: - Private Helpers

private extension StudentLocationsPostInformationViewController {
    
    struct UIConstants {
        static let BtnBkndFileName = "WhitePixel"
    }
    
    struct ButtonTitle {
        static let Find   = "Find On The Map"
        static let Submit = "Submit"
    }
    
    struct PlaceholderText {
        static let Attributes    = [NSForegroundColorAttributeName: UIColor.white]
        static let LocationField = "Enter Your Location Here"
        static let MediaURLField = "Enter a Link to Share Here"
    }
    
    func addSubviews() {
        questionLabels.forEach({view.addSubview($0)})
        
        view.addSubview(cancelButton)
        view.addSubview(mapView)
        view.addSubview(imageView)
        view.addSubview(toolbar)
        view.addSubview(mediaURLTextField)
        view.addSubview(locationTextField)
        
        pleaseWaitView = PleaseWaitView(requestingView: view)
        view.addSubview((pleaseWaitView?.dimmedView)!)
        view.bringSubview(toFront: (pleaseWaitView?.dimmedView)!)
    }
    
    func findOnTheMap() {
        
        if locationTextField.text!.isEmpty {
            presentAlert(Alert.Title.BadGeocode, message: Alert.Message.LocationNotEntered)
        } else {
            let geocoder = CLGeocoder()
            NetworkActivityIndicatorManager.shared.startActivity();
            pleaseWaitView!.startActivityIndicator()
            geocoder.geocodeAddressString(locationTextField.text!, completionHandler: geocodeCompletionHandler)
        }
        
    }
    
    func setInitialFieldValues() {
        
        if let _ = newStudent {
            currentStudentLocation = StudentLocation()
            currentStudentLocation?.firstName = newStudent!.firstName
            currentStudentLocation?.lastName  = newStudent!.lastName
            currentStudentLocation?.uniqueKey = newStudent!.udacityUserID
        } else {
            locationTextField.text = currentStudentLocation?.mapString
            mediaURLTextField.text = currentStudentLocation?.mediaURL
            locationTextField.clearsOnBeginEditing = false
            mediaURLTextField.clearsOnBeginEditing = false
        }
        
    }
    
    func setInitialSubviewVisibility() {
        imageView.isHidden         = false
        locationTextField.isHidden = false
        questionLabels.forEach({$0.isHidden = false})
        
        mediaURLTextField.isHidden = true
        mapView.isHidden	       = true
    }
    
    func setTextFieldPlaceholders() {
        locationTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.LocationField, attributes: PlaceholderText.Attributes)
        mediaURLTextField.attributedPlaceholder = NSAttributedString(string: PlaceholderText.MediaURLField, attributes: PlaceholderText.Attributes)
    }
    
    func setToolbarButtonBackground() {
        let buttonBackground = UIImage(named: UIConstants.BtnBkndFileName)
        buttonBackground?.resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        toolbarButton.setBackgroundImage(buttonBackground, for: UIControlState(), barMetrics: .default)
        toolbarButton.title = ButtonTitle.Find
    }
    
    func submit() {
        
        if mediaURLTextField.text!.isEmpty {
            presentAlert(Alert.Title.BadSubmit, message: Alert.Message.URLNotEntered)
        } else {
            currentStudentLocation?.mediaURL = mediaURLTextField.text!
            
            if let _ = newStudent {
                ParseAPIClient.shared.postStudentLocation(currentStudentLocation!, completionHandler: postStudentLocationCompletionHandler)
            } else {
                ParseAPIClient.shared.updateStudentLocation(currentStudentLocation!, completionHandler: updateStudentLocationCompletionHandler)
            }
            
        }
        
    }
    
    func transitionToMapAndURL(_ annotation: MKPointAnnotation, region: MKCoordinateRegion) {
        view.backgroundColor = imageView.backgroundColor
        toolbarButton.title  = ButtonTitle.Submit
        toolbar.backgroundColor = UIColor.clear
        toolbar.isTranslucent = true
        cancelButton.setTitleColor(UIColor.white, for: UIControlState())
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
        mapView.isHidden = false
        
        imageView.isHidden         = true
        locationTextField.isHidden = true
        mediaURLTextField.isHidden = false
        questionLabels.forEach({$0.isHidden = true})
    }
    
}
