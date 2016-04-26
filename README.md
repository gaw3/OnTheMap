# ![App Icon](./Paperwork/images/OnTheMap_80.png)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OnTheMap

OnTheMap allows a Udacity student to share his location, and a URL of interest, with other students.  The locations specified in the 100 most-recent student postings are presented as pins on a map or as items in a table.  The student postings database is hosted on the Parse platform.  The app requires login via Udacity or Facebook.

## Project

OnTheMap is Portfolio Project #3 of the Udacity iOS Developer Nanodegree Program.  The following list contains pertinent course documents:
* [Udacity App Specification](./Paperwork/Udacity/UdacityAppSpecification.pdf)  
* [Udacity Grading Rubric](./Paperwork/Udacity/UdacityGradingRubric.pdf)  
* [GitHub Swift Style Guide](./Paperwork/Udacity/GitHubSwiftStyleGuide.pdf)  
* [Udacity Git Commit Message Style Guide](./Paperwork/Udacity/UdacityGitCommitMessageStyleGuide.pdf)  
* [Udacity Project Review](./Paperwork/Udacity/ProjectReview.pdf)<br/><br/>

|               | Project Submission         | Current State |
| :----------   | :-------------             | :----------- |
| Grade:        | ***Exceeds Expectations*** |               |
| GitHub Tag:   | v1.1                       | v1.3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[changelog](./Paperwork/READMEFiles/ChangeLog.md)|
| App Version:  | 1.1                        | 1.3 |
| Environment:  | Xcode 7.2.1 / iOS 9.2      | Xcode 7.3 / iOS 9.3 |
| Devices:      | iPhone Only                | same |
| Orientations: | Portrait Only              | same |

## Design  

### Udacity Login View

Upon app launch, the initial view is the [Udacity Login View](./Paperwork/READMEFiles/UdacityLoginView.md).

The user must have a Udacity account to be able to login with this app.  If the user does not have an account, tap the **Sign Up!** button in order to open the system browser with the [Udacity Sign Up](./Paperwork/READMEFiles/UdacitySignUpWebpage.md) webpage.

Enter email address and password, and tap the **Login** button in order to login with Udacity authentication.

Tap on the **Log in with Facebook** button in order to login with Facebook authentication.  Email address and password fields are ignored.

### Student Location Tabbed View

Upon successful login, the [Student Locations Tabbed View](./Paperwork/READMEFiles/StudentLocationsTabbedView.md) is presented with the [Map tab](./Paperwork/READMEFiles/StudentLocationsTabbedView.md) activated.  

The [Map tab](./Paperwork/READMEFiles/StudentLocationsTabbedView.md) is the default tab, and presents a map view with pins dropped at the locations specified in the 100 most-recent student postings.  Tap a pin to display an annotation containing the students name and URL of interest.  Tap the annotation to open the system browser with that URL (provided the URL is valid).  All pins are red except for the user's pin, which is green.

Tap the [List tab](./Paperwork/READMEFiles/StudentLocationsTabbedView.md) to display a table view containing information from the 100 most-recent student postings, sorted by most-recent update time.  Each row of the table contains the name, location & URL of interest.  Tap a row to open the system browser with the contained URL (provided the URL is valid).  The two tabs share a common navigation bar containing the following buttons:

* Logout - tap to logout from Udacity, and optionally, Facebook.  The [Student Location Tabbed View](./Paperwork/READMEFiles/StudentLocationsTabbedView.md) disappears, and the [Udacity Login View](./Paperwork/READMEFiles/UdacityLoginView.md) is displayed.  

* Post ![Pin Button](./Paperwork/images/PinIcon.png) - Tap to present the Post Student Location View to allow for student location entry.  If this is the user's first post, the Post Student Location View is presented straightaway.  Otherwise, a **Confirm Update or Cancel** alert appears.  Tap **Confirm** to present the Post Student Location View with text fields populated with current data.

* Refresh ![Refresh Button](./Paperwork/images/RefreshIcon.png) - Tap to retrieve a new list of the 100 most-recent student postings, sorted by most-recent update time.

### Post Student Location View

The Post Student Location View first presents an ["Enter Location"](./Paperwork/READMEFiles/PostStudentLocationView.md) view.

Enter a location into the **Enter Your Location Here** field and tap the **Find On A Map** button to initiate forward-geocoding of said location.  If forward-geocoding is successful, the view transitions to the ["Enter Link"](./Paperwork/READMEFiles/PostStudentLocationView.md) view and a map appears.  The map is animated to zoom in on the said location and drop a green pin.

Enter a URL in the **Enter a Link to Share Here** field and tap the **Submit** button in order to initiate the student posting.  The Post Student Location View then disappears, and the current tab of the [Student Location Tabbed View](./Paperwork/READMEFiles/StudentLocationsTabbedView.md) is displayed.

Tap the **Cancel** button in the upper right-hand corner at any time to interrupt the posting and return to the current tab of the [Student Location Tabbed View](./Paperwork/READMEFiles/StudentLocationsTabbedView.md).

### General

* Implemented the ```FBSDKLoginButtonDelegate``` protocol.
* The network activity indicator in the status bar is enabled when the app is performing network operations.
* Network operations & time-consuming data operations are performed asynchronously on background queues via GCD.
* Local notifications are posted to inform interested view controllers that:
  - the local copy of the student location database has been modified
  - various steps in the Udacity login/logout sequence have completed

### iOS Frameworks & GCD

- [CoreLocation](./Paperwork/READMEFiles/CoreLocation.md)
- [Foundation](./Paperwork/READMEFiles/Foundation.md)
- [Grand Central Dispatch](./Paperwork/READMEFiles/GCD.md)
- [MapKit](./Paperwork/READMEFiles/MapKit.md)
- [UIKit](./Paperwork/READMEFiles/UIKit.md)

### Web APIs In Use

[Udacity API](./Paperwork/APIs/UdacityAPIOverview.pdf) - login/logout with Udacity email/password or Facebook Authentication Token; retrieve Udacity user profile data.

[Parse API](./Paperwork/APIs/ParseAPIOverview.pdf) - modify data in, and retrieve data from, the student location database hosted on the Facebook Parse platform.  [Website](https://parse.com) and [Terms of Service](https://parse.com/policies)

### 3rd-Party

* `FBSDKCoreKit` & `FBSDKLoginKit` from Facebook SDK for iOS (v4.9.1).
  - [REPO](https://github.com/facebook/facebook-ios-sdk)
  - [LICENSE](./Paperwork/Licenses/FacebookSDK_LICENSE.txt)
  - [README](./Paperwork/Licenses/FacebookSDK_README.txt)
* *GitHub Swift Style Guide* lives in this [repo](https://github.com/github/swift-style-guide).
* `Swift.gitignore`, the template used to create the local `.gitignore` file, lives in this [repo](https://github.com/github/gitignore).

---
**Copyright © 2016 Gregory White. All rights reserved.**
