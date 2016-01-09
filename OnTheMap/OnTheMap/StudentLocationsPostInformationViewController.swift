//
//  StudentLocationsPostInformationViewController.swift
//  OnTheMap
//
//  Created by Gregory White on 1/7/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import MapKit
import UIKit

class StudentLocationsPostInformationViewController: UIViewController, MKMapViewDelegate {

   @IBOutlet weak var questionLabel: UILabel!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var toolbarButton: UIBarButtonItem!

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	@IBAction func toolbarButtonWasTapped(sender: UIBarButtonItem) {
		print("\(sender.title) button was tapped")
	}
}
