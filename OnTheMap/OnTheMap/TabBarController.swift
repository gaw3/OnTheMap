//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Gregory White on 3/13/20.
//  Copyright © 2020 Gregory White. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - IB Actions
    
    @IBAction func unwindToTabBarController(_ segue: UIStoryboardSegue) {
        print("did unwind to tab bar controller")
    }
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapControllerNC  = storyboard?.instantiateViewController(withIdentifier: "MapControllerNC") as! UINavigationController
        let listControllerNC = storyboard?.instantiateViewController(withIdentifier: "ListControllerNC") as! UINavigationController
        viewControllers = [mapControllerNC, listControllerNC]
    }
    
}
