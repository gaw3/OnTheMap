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
    
    @IBAction func pinButtonWasTapped(_ button: UIBarButtonItem) {
        ParseAPIClient.shared.getStudentLocation(forUserID: UdacityDataManager.shared.user!.userID, completionHandler: finishGettingStudentLocation)
    }
    
    @IBAction func refreshButtonWasTapped(_ button: UIBarButtonItem) {
        ParseAPIClient.shared.refreshStudentLocations(completionHandler: finishRefreshingStudentLocations)
    }
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseAPIClient.shared.refreshStudentLocations(completionHandler: finishRefreshingStudentLocations)
    }
    
}



// MARK: -
// MARK: - Private Completion Handlers

private extension StudentLocationsTabBarController {
    
    var finishGettingStudentLocation: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                var message = String()
                
                switch error!.code {
                case LocalizedError.Code.Network: message = Alert.Message.NetworkUnavailable
                case LocalizedError.Code.HTTP:    message = Alert.Message.HTTPError
                default:                          message = Alert.Message.BadServerData
                }
                
                strongSelf.presentAlert(title: Alert.Title.BadGet, message: message)
                return
            }

            let results = (result as! JSONDictionary)[ParseAPIClient.API.ResultsKey] as? [JSONDictionary]
            
            if results!.isEmpty {
                let postInfoVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.StudentLocsPostInfoVC) as! StudentLocationsPostInformationViewController
                
                postInfoVC.newStudent = (UdacityDataManager.shared.user!.firstName, UdacityDataManager.shared.user!.lastName, UdacityDataManager.shared.user!.userID)
                
                DispatchQueue.main.async(execute:  {
                    strongSelf.present(postInfoVC, animated: true, completion: nil)
                })
                
            } else {
                let alert     = UIAlertController(title: Alert.Title.AlreadyPosted, message: Alert.Message.IsUpdateDesired, preferredStyle: .alert)
                let noAction  = UIAlertAction(title: Alert.ActionTitle.No, style: .cancel, handler: nil )
                
                let yesAction = UIAlertAction(title: Alert.ActionTitle.Yes, style: .default, handler: { (action) -> Void in
                    let postInfoVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.StudentLocsPostInfoVC) as! StudentLocationsPostInformationViewController
                    postInfoVC.currentStudentLocation = StudentLocation(studentLocationDict: results!.first! as JSONDictionary)
                    
                    DispatchQueue.main.async(execute:  {
                        strongSelf.present(postInfoVC, animated: true, completion: nil)
                    })
                    
                })
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                DispatchQueue.main.async(execute:  {
                    strongSelf.present(alert, animated: true, completion: nil)
                })
                
            }
            
        }
        
    }
    
    var finishRefreshingStudentLocations: APIDataTaskWithRequestCompletionHandler {
        
        return { [weak self] (result, error) -> Void in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                var message = String()
                
                switch error!.code {
                case LocalizedError.Code.Network: message = Alert.Message.NetworkUnavailable
                case LocalizedError.Code.HTTP:    message = Alert.Message.HTTPError
                default:                          message = Alert.Message.BadServerData
                }
                
                strongSelf.presentAlert(title: Alert.Title.BadRefresh, message: message)
                return
            }

            let results = (result as! JSONDictionary)[ParseAPIClient.API.ResultsKey] as! [JSONDictionary]?
            
            guard !results!.isEmpty else {
                strongSelf.presentAlert(title: Alert.Title.BadRefresh, message: Alert.Message.NoJSONData)
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
