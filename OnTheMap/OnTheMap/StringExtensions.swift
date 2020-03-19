//
//  StringExtensions.swift
//  OnTheMap
//
//  Created by Gregory White on 3/18/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import UIKit

extension String {
    
    var isValidURL: Bool {
        
        guard let urlComponents = URLComponents(string: self) else {
            return false
        }
        
        guard UIApplication.shared.canOpenURL(urlComponents.url!) else {
             return false
        }

        return true
    }
    
}
