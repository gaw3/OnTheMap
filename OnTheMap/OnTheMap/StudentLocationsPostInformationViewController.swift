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
    
    // MARK: - View Events
    
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



// MARK: -
// MARK: - Text Field Delegate

extension StudentLocationsPostInformationViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        assert(textField == mediaURLTextField || textField == locationTextField, "unknown UITextField = \(textField)")
        
        textField.resignFirstResponder()
        return true
    }
    
}



// MARK: -
// MARK: - Private Completion Handlers

private extension StudentLocationsPostInformationViewController {
    
    var finishGeocoding: CLGeocodeCompletionHandler {
        
        return { [weak self] (placemarks, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async(execute: {
                NetworkActivityIndicator.shared.stop()
                strongSelf.pleaseWaitView!.stopActivityIndicator()
            })
            
            guard error == nil else {
                strongSelf.presentAlert(title: Alert.Title.BadGeocode, message: error!.localizedDescription)
                return
            }
            
            guard placemarks != nil, !placemarks!.isEmpty else {
                strongSelf.presentAlert(title: Alert.Title.BadGeocode, message: Alert.Message.NoPlacemarks)
                return
            }
            
            let studentLocationPlacemark = placemarks![0] as CLPlacemark
            
            strongSelf.currentStudentLocation?.mapString = strongSelf.locationTextField.text!
            strongSelf.currentStudentLocation?.latitude  = studentLocationPlacemark.location!.coordinate.latitude
            strongSelf.currentStudentLocation?.longitude = studentLocationPlacemark.location!.coordinate.longitude
            
            var deltaDegrees: CLLocationDegrees
            
            if let _ = studentLocationPlacemark.thoroughfare  { deltaDegrees = 0.2 }
            else if let _ = studentLocationPlacemark.locality { deltaDegrees = 0.5 }
            else                                              { deltaDegrees = 12.0 }
            
            let studentLocationAnnotation = MKPointAnnotation()
            studentLocationAnnotation.coordinate = (studentLocationPlacemark.location?.coordinate)!
            
            let studentLocationRegion = MKCoordinateRegion(center: (studentLocationPlacemark.location?.coordinate)!,
                                                           span: MKCoordinateSpanMake(deltaDegrees, deltaDegrees))
            
            DispatchQueue.main.async(execute: {
                strongSelf.transitionToMapAndURL(studentLocationAnnotation, region: studentLocationRegion)
            })
            
        }
        
    }
    
    var finishPostingStudentLocation: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            NetworkActivityIndicator.shared.stop()

            guard let strongSelf = self else { return }

            guard error == nil else {
                strongSelf.processError(error!, alertTitle: Alert.Title.BadPost)
                return
            }
            
            let responseData = ParsePostStudentLocationResponseData(dict: result as! JSONDictionary)
            
            strongSelf.currentStudentLocation!.dateCreated = responseData.dateCreated
            strongSelf.currentStudentLocation!.dateUpdated = responseData.dateCreated
            strongSelf.currentStudentLocation!.objectID    = responseData.id
            
            DispatchQueue.main.async(execute: {
                
                strongSelf.dismiss(animated: true, completion: {
                    StudentLocationsManager.shared.postedLocation = strongSelf.currentStudentLocation!
                })
            
            })
            
        }
        
    }
    
    var finishUpdatingStudentLocation: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            NetworkActivityIndicator.shared.stop()
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                strongSelf.processError(error!, alertTitle: Alert.Title.BadUpdate)
                return
            }
            
            let responseData = ParseUpdateStudentLocationResponseData(dict: result as! JSONDictionary)
            
            strongSelf.currentStudentLocation!.dateUpdated = responseData.dateUpdated
            
            DispatchQueue.main.async(execute: {
                
                strongSelf.dismiss(animated: true, completion: {
                    StudentLocationsManager.shared.update(studentLocation: strongSelf.currentStudentLocation!)
                })
            
            })
            
        }
        
    }
    
    func processError(_ error: NSError, alertTitle: String) {
        var message = String()
        
        switch error.code {
        case LocalizedError.Code.Network: message = Alert.Message.NetworkUnavailable
        case LocalizedError.Code.HTTP:    message = Alert.Message.HTTPError
        default:                          message = Alert.Message.BadServerData
        }
        
        presentAlert(title: Alert.Title.BadUpdate, message: message)
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
            presentAlert(title: Alert.Title.BadGeocode, message: Alert.Message.LocationNotEntered)
        } else {
            let geocoder = CLGeocoder()
            NetworkActivityIndicator.shared.start();
            pleaseWaitView!.startActivityIndicator()
            geocoder.geocodeAddressString(locationTextField.text!, completionHandler: finishGeocoding)
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
        mediaURLTextField.isHidden = true
        mapView.isHidden	       = true
        questionLabels.forEach({$0.isHidden = false})
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
            presentAlert(title: Alert.Title.BadSubmit, message: Alert.Message.URLNotEntered)
        } else {
            currentStudentLocation?.mediaURL = mediaURLTextField.text!
            
            if let _ = newStudent {
                ParseAPIClient.shared.post(studentLocation: currentStudentLocation!, completionHandler: finishPostingStudentLocation)
            } else {
                ParseAPIClient.shared.update(studentLocation: currentStudentLocation!, completionHandler: finishUpdatingStudentLocation)
            }
            
        }
        
    }
    
    func transitionToMapAndURL(_ annotation: MKPointAnnotation, region: MKCoordinateRegion) {
        view.backgroundColor    = imageView.backgroundColor
        toolbarButton.title     = ButtonTitle.Submit
        toolbar.backgroundColor = UIColor.clear
        toolbar.isTranslucent   = true
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
