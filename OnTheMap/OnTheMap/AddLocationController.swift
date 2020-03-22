//
//  AddLocationController.swift
//  OnTheMap
//
//  Created by Gregory White on 3/17/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import CoreLocation
import UIKit

final class AddLocationController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField:  UITextField!
    @IBOutlet weak var locationField:  UITextField!
    @IBOutlet weak var urlField:       UITextField!
    @IBOutlet weak var addButton:      UIButton!
    
    // MARK: - IB Actions
    
    @IBAction func didTouchUpInside(_ button: UIButton) {
        
        guard !firstNameField.text!.isEmpty else {
            presentAlert(title: "Invalid Student Location Data", message: "First name field is empty")
            return
        }
        
        guard !lastNameField.text!.isEmpty else {
            presentAlert(title: "Invalid Input Data", message: "Last name field is empty")
            return
        }
        
        guard !locationField.text!.isEmpty else {
            presentAlert(title: "Invalid Input Data", message: "Location field is empty")
            return
        }
        
        guard !urlField.text!.isEmpty else {
            presentAlert(title: "Invalid Input Data", message: "URL field is empty")
            return
        }
        
        guard urlField.text!.isValidURL else {
            presentAlert(title: "Bad URL", message: "The URL string is malformed")
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationField.text!, completionHandler: finishGeocoding)
    }
    
}



// MARK: -
// MARK: - Private Completion Handlers

private extension AddLocationController {
    
    var finishGeocoding: CLGeocodeCompletionHandler {
        
        return { [weak self] (placemarks, error) -> Void in
            
            guard let strongSelf = self else { return }
                        
            guard error == nil else {
                strongSelf.presentAlert(title: Alert.Title.BadGeocode, message: error!.localizedDescription)
                return
            }
            
            guard placemarks != nil, !placemarks!.isEmpty else {
                strongSelf.presentAlert(title: Alert.Title.BadGeocode, message: Alert.Message.NoPlacemarks)
                return
            }
            
            let addedLocationAnnotation = AddedLocationAnnotation(placemark: placemarks![0] as CLPlacemark,
                                                                  firstName: strongSelf.firstNameField.text!,
                                                                   lastName: strongSelf.lastNameField.text!,
                                                                        url: strongSelf.urlField.text!)
            
            DispatchQueue.main.async(execute: {
                let verifyLocationVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "VerifyLocationVC") as! VerifyLocationController
                verifyLocationVC.addedLocationAnnotation = addedLocationAnnotation
                strongSelf.navigationController?.pushViewController(verifyLocationVC, animated: true)
            })
            
        }
        
    }
    
}
