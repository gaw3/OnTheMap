//
//  UIViewExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 3/22/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    func configure() {
        backgroundColor          = .gray
        selectedSegmentTintColor = .white
        
        setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        setTitleTextAttributes([.foregroundColor : UIColor.black], for: .selected)
    }
    
}
