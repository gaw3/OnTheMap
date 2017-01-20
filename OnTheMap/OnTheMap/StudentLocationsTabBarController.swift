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
        ParseAPIClient.shared.getStudentLocation(withUserID: UdacityDataManager.shared.user!.userID, completionHandler: getStudentLocationCompletionHandler)
    }
    
    @IBAction func refreshButtonWasTapped(_ sender: UIBarButtonItem) {
        ParseAPIClient.shared.refreshStudentLocations(refreshStudentLocationsCompletionHandler)
    }
    
    // MARK: - View Management
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        ParseAPIClient.shared.refreshStudentLocations(refreshStudentLocationsCompletionHandler)
    }
    
}



// MARK: -
// MARK: - Private Completion Handlers

private extension StudentLocationsTabBarController {
    
    var getStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                strongSelf.presentAlert(Alert.Title.BadGet, message: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                strongSelf.presentAlert(Alert.Title.BadGet, message: Alert.Message.NoJSONData)
                return
            }
            
            let results = (result as! JSONDictionary)[ParseAPIClient.API.ResultsKey] as? [JSONDictionary]
            
            if results!.isEmpty {
                let postInfoVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.StudentLocsPostInfoVC) as! StudentLocationsPostInformationViewController
                
                postInfoVC.newStudent = (UdacityDataManager.shared.user!.firstName, UdacityDataManager.shared.user!.lastName, UdacityDataManager.shared.user!.userID)
                
                strongSelf.present(postInfoVC, animated: true, completion: nil)
            } else {
                let alert     = UIAlertController(title: Alert.Title.AlreadyPosted, message: Alert.Message.IsUpdateDesired, preferredStyle: .alert)
                let noAction  = UIAlertAction(title: Alert.ActionTitle.No, style: .cancel, handler: nil )
                
                let yesAction = UIAlertAction(title: Alert.ActionTitle.Yes, style: .default, handler: { (action) -> Void in
                    let postInfoVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.StudentLocsPostInfoVC) as! StudentLocationsPostInformationViewController
                    postInfoVC.currentStudentLocation = StudentLocation(studentLocationDict: results!.first! as JSONDictionary)
                    strongSelf.present(postInfoVC, animated: true, completion: nil)
                })
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                strongSelf.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    var refreshStudentLocationsCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                strongSelf.presentAlert(Alert.Title.BadRefresh, message: error!.localizedDescription)
                return
            }
            
            guard result != nil else {
                strongSelf.presentAlert(Alert.Title.BadRefresh, message: Alert.Message.NoJSONData)
                return
            }
            
            let results = (result as! JSONDictionary)[ParseAPIClient.API.ResultsKey] as! [JSONDictionary]?
            
            guard !(results!.isEmpty) else {
                strongSelf.presentAlert(Alert.Title.BadRefresh, message: Alert.Message.NoJSONData)
                return
            }
            
            var newStudentLocations = [StudentLocation]()
            
            for newStudentLocation: JSONDictionary in results! {
                newStudentLocations.append(StudentLocation(studentLocationDict: newStudentLocation))
            }
            
            StudentLocationsManager.shared.refresh(studentLocations: newStudentLocations)
        }
        
    }
    
}
