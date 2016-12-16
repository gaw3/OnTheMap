//
//  StudentLocationsTabBarController.swift
//  OnTheMap
//
//  Created by Gregory White on 1/15/16.
//  Copyright © 2016 Gregory White. All rights reserved.
//

import UIKit

final  class StudentLocationsTabBarController: UITabBarController {
    
    // MARK: - Private Constants
    
    fileprivate struct Alert {
        
        struct ActionTitle {
            static let Yes = "Yes"
            static let No  = "No"
        }
        
        struct Message {
            static let IsUpdateDesired = "Would you like to update your location?"
            static let NoJSONData      = "JSON data unavailable"
        }
        
        struct Title {
            static let AlreadyPosted = "Your location already posted"
            static let BadGet        = "Unable to find student location"
            static let BadRefresh    = "Unable to refresh list of student locations"
        }
        
    }
    
    // MARK: - View Events
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        parseClient.refreshStudentLocations(refreshStudentLocationsCompletionHandler)
    }
    
    // MARK: - IB Actions
    
    @IBAction  func pinButtonWasTapped(_ sender: UIBarButtonItem) {
        parseClient.getStudentLocation(udacityDataMgr.user!.userID!, completionHandler: getStudentLocationCompletionHandler)
    }
    
    @IBAction  func refreshButtonWasTapped(_ sender: UIBarButtonItem) {
        parseClient.refreshStudentLocations(refreshStudentLocationsCompletionHandler)
    }
    
    // MARK: - Private:  Completion Handlers as Computed Variables
    
    fileprivate var getStudentLocationCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
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
                let postInfoVC = self.storyboard?.instantiateViewController(withIdentifier: IB.StoryboardID.StudentLocsPostInfoVC)
                    as! StudentLocationsPostInformationViewController
                
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
    
    fileprivate var refreshStudentLocationsCompletionHandler: APIDataTaskWithRequestCompletionHandler {
        
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
