//
//  VerifyLocationController.swift
//  OnTheMap
//
//  Created by Gregory White on 3/18/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import MapKit
import UIKit

final class VerifyLocationController: UIViewController {
    
    // MARK: - IB Outlets

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var mapView:      MKMapView!
    
    // MARK: - IB Actions

    @IBAction func didTouchUpInside(_ button: UIButton) {
        
        switch button {
            
        case finishButton:
            dataMgr.addedLocations.add(annotation: addedLocationAnnotation)
            performSegue(withIdentifier: "UnwindSegueToTabBarController", sender: self)
            
        default:
            assertionFailure("Received event from unknown button")
        }
        
    }
    
    // MARK: - Variables

    var addedLocationAnnotation: AddedLocationAnnotation!
    
    // MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.addAnnotation(addedLocationAnnotation)
        mapView.setRegion(addedLocationAnnotation.region, animated: true)
        mapView.regionThatFits(addedLocationAnnotation.region)
    }
    
}



// MARK: -
// MARK: - Map View Delegate

extension VerifyLocationController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = mapView.dequeueReusableAnnotationView(withIdentifier: IB.ReuseID.StudentLocsPinAnnoView) as? MKMarkerAnnotationView ??
                     MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: IB.ReuseID.StudentLocsPinAnnoView)
        
        addedLocationAnnotation.configure(annotationView: marker)
        return marker
    }
    
}
