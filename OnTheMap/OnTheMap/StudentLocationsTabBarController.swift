//
//  StudentLocationsTabBarController.swift
//  OnTheMap
//
//  Created by Gregory White on 1/15/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

final class StudentLocationsTabBarController: UITabBarController {
    
    // MARK: - IB Actions
    
    @IBAction func pinButtonWasTapped(_ sender: UIBarButtonItem) {
        ParseAPIClient.shared.getStudentLocation(withUserID: udacityDataMgr.user!.userID!, completionHandler: getStudentLocationCompletionHandler)
    }
    
    @IBAction func refreshButtonWasTapped(_ sender: UIBarButtonItem) {
        ParseAPIClient.shared.refreshStudentLocations(refreshStudentLocationsCompletionHandler)
    }
    
    // MARK: - View Events
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        ParseAPIClient.shared.refreshStudentLocations(refreshStudentLocationsCompletionHandler)
    }
    
}



// MARK: -
// MARK: - Private Completion Handlers

private extension StudentLocationsTabBarController {
    
    var getStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { (result, error) -> Void in
            
            guard error == nil else {
                self.presentAlert(Alert.Title.BadGet, message: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                self.presentAlert(Alert.Title.BadGet, message: Alert.Message.NoJSONData)
                return
            }
            
            let results = (result as! JSONDictionary)[ParseAPIClient.API.ResultsKey] as? [JSONDictionary]
            
            if results!.isEmpty {
                let postInfoVC = self.storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.StudentLocsPostInfoVC) as! StudentLocationsPostInformationViewController
                
                postInfoVC.newStudent = (self.udacityDataMgr.user!.firstName!,
                                         self.udacityDataMgr.user!.lastName!,
                                         self.udacityDataMgr.user!.userID!)
                
                self.present(postInfoVC, animated: true, completion: nil)
            } else {
                let alert     = UIAlertController(title: Alert.Title.AlreadyPosted, message: Alert.Message.IsUpdateDesired, preferredStyle: .alert)
                let noAction  = UIAlertAction(title: Alert.ActionTitle.No, style: .cancel, handler: nil )
                
                let yesAction = UIAlertAction(title: Alert.ActionTitle.Yes, style: .default, handler: { (action) -> Void in
                    let postInfoVC = self.storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.StudentLocsPostInfoVC)
                        as! StudentLocationsPostInformationViewController
                    postInfoVC.currentStudentLocation = StudentLocation(studentLocationDict: results!.first! as JSONDictionary)
                    self.present(postInfoVC, animated: true, completion: nil)
                })
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    var refreshStudentLocationsCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { (result, error) -> Void in
            
            guard error == nil else {
                self.presentAlert(Alert.Title.BadRefresh, message: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                self.presentAlert(Alert.Title.BadRefresh, message: Alert.Message.NoJSONData)
                return
            }
            
            let results = (result as! JSONDictionary)[ParseAPIClient.API.ResultsKey] as! [JSONDictionary]?
            
            guard !(results!.isEmpty) else {
                self.presentAlert(Alert.Title.BadRefresh, message: Alert.Message.NoJSONData)
                return
            }
            
            var newStudentLocations = [StudentLocation]()
            
            for newStudentLocation: JSONDictionary in results! {
                newStudentLocations.append(StudentLocation(studentLocationDict: newStudentLocation))
            }
            
            StudentLocationsManager.shared.refreshStudentLocations(newStudentLocations)
        }
        
    }
    
}
