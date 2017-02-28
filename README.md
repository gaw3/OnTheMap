# ![][AppIcon]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OnTheMap

OnTheMap allows a Udacity student to share his location, and a URL of interest, with other students.  The locations specified in the 100 most-recent student postings are presented as pins on a map or as items in a table.  The student postings database is hosted on a Udacity server using a local copy of Parse.

## Project

OnTheMap is Portfolio Project #3 of the Udacity iOS Developer Nanodegree Program.  The following list contains pertinent course documents:

* [Udacity App Specification][AppSpec]
* [Udacity Grading Rubric][GradingRubric]
* [GitHub Swift Style Guide][SwiftStyleGuide]
* [Udacity Git Commit Message Style Guide][CommitMsgStyleGuide]
* [Udacity Project Review][ProjectReview]<br/><br/>

| [Change Log][ChangeLog] | Current iOS 10 Build   | Final iOS 9 Build   | Project Submission - ***Exceeds Expectations*** |
| :----------             | :-----------------     | :-------------      | :-------------                                  |
| GitHub Tag              | v2.0                   | v1.3                | v1.1                                            |
| App Version:            | 2.0                    | 1.3                 | 1.1                                             |
| Environment:            | Xcode 8.2.1 / iOS 10.2 | Xcode 7.3 / iOS 9.3 | Xcode 7.2.1 / iOS 9.2                           |
| Devices:                | iPhone Only            | iPhone Only         | iPhone Only                                     |
| Orientations:           | Portrait Only          | Portrait Only       | Portrait Only                                   |

**NOTA BENE:**  Runtime warnings will appear when running on the simulator due to simulator bugs;  however, running on a device with debugger attached will show that the runtime warnings do not appear.  See those runtime warnings [here][RWarn].

## Design  

### Udacity Login View

Upon app launch, the initial view is the [Udacity Login View][ULV].

The user must have a Udacity account to be able to login with this app.  If the user does not have an account, tap the **Sign Up!** button in order to open the system browser with the [Udacity Sign Up][USU] webpage.

Enter email address and password, and tap the **Login** button in order to login with Udacity authentication.

Tap on the **Continue with Facebook** button in order to login with Facebook authentication.  Email address and password fields are ignored.

### Student Location Tabbed View

Upon successful login, the [Student Locations Tabbed View][SLTV] is presented with the [Map Tab][SLTV] activated.  

The [Map Tab][SLTV] is the default tab, and presents a map view with pins dropped at the locations specified in the 100 most-recent student postings.  Tap a pin to display an annotation containing the students name and URL of interest.  Tap the annotation to open the system browser with that URL (provided the URL is valid).  All pins are red except for the user's pin, which is green.

Tap the [List Tab][SLTV] to display a table view containing information from the 100 most-recent student postings, sorted by most-recent update time.  Each row of the table contains the name, location & URL of interest.  Tap a row to open the system browser with the contained URL (provided the URL is valid).  The two tabs share a common navigation bar containing the following buttons:

* Logout - tap to logout from Udacity, and optionally, Facebook.  The [Student Location Tabbed View][SLTV] disappears, and the [Udacity Login View][ULV] is displayed.  

* Post ![][PinButton] - Tap to present the Post Student Location View to allow for student location entry.  If this is the user's first post, the Post Student Location View is presented straightaway.  Otherwise, a **Confirm Update or Cancel** alert appears.  Tap **Confirm** to present the Post Student Location View with text fields populated with current data.

* Refresh ![][RefreshButton] - Tap to retrieve a new list of the 100 most-recent student postings, sorted by most-recent update time.

### Post Student Location View

[PSLV]: ./Paperwork/READMEFiles/PostStudentLocationView.md

The Post Student Location View first presents an ["Enter Location"][PSLV] view.

Enter a location into the **Enter Your Location Here** field and tap the **Find On A Map** button to initiate forward-geocoding of said location.  If forward-geocoding is successful, the view transitions to the ["Enter Link"][PSLV] view and a map appears.  The map is animated to zoom in on said location and drop a green pin.

Enter a URL in the **Enter a Link to Share Here** field and tap the **Submit** button in order to initiate the student posting.  The Post Student Location View then disappears, and the current tab of the [Student Location Tabbed View][SLTV] is displayed.

Tap the **Cancel** button in the upper right-hand corner at any time to interrupt the posting and return to the current tab of the [Student Location Tabbed View][SLTV].

### General

* Implemented the ```FBSDKLoginButtonDelegate``` protocol.
* The network activity indicator in the status bar is enabled when the app is performing network operations.
* Network operations & time-consuming data operations are performed asynchronously on background queues via GCD.
* Local notifications are posted to inform interested view controllers that:
  - the local copy of the student location database has been modified
  - various steps in the Udacity login/logout sequence have completed

### iOS Frameworks

* CoreLocation
* Foundation
* Grand Central Dispatch
* MapKit
* UIKit

### Web APIs

* [Udacity API][UAPI] - login/logout with Udacity email/password or Facebook Authentication Token; retrieve Udacity user profile data.
* [Parse API][PAPI] - access student location database hosted on Udacity server using a local copy of Parse.

### 3rd-Party

* Facebook SDK for **iOS 9** (v4.19.0).&nbsp;&nbsp;iOS 10 version not available.&nbsp;&nbsp;[Repo][FBRepo], [License][FBLicense] & [README][FBREADME].
  - ```Bolts.framework```
  - ```FBSDKCoreKit.framework```
  - ```FBSDKLoginKit.framework```
* *GitHub Swift Style Guide* lives in this [repo][StyleGuideRepo].
* `Swift.gitignore`, the template used to create the local `.gitignore` file, lives in this [repo][GitIgnoreRepo].

---
**Copyright © 2016-2017 Gregory White. All rights reserved.**





[ChangeLog]:            ./Paperwork/READMEFiles/ChangeLog.md
[SLTV]:                 ./Paperwork/READMEFiles/StudentLocationsTabbedView.md
[ULV]:                  ./Paperwork/READMEFiles/UdacityLoginView.md
[USU]:                  ./Paperwork/READMEFiles/UdacitySignUpWebpage.md

[CL]:                   ./Paperwork/READMEFiles/CoreLocation.md
[FDTN]:                 ./Paperwork/READMEFiles/Foundation.md
[GCD]:                  ./Paperwork/READMEFiles/GCD.md
[MK]:                   ./Paperwork/READMEFiles/MapKit.md
[RWarn]:                ./Paperwork/READMEFiles/RuntimeWarnings.md
[UK]:                   ./Paperwork/READMEFiles/UIKit.md 

[AppIcon]:              ./Paperwork/images/OnTheMap_80.png
[PinButton]:            ./Paperwork/images/PinIcon.png
[RefreshButton]:        ./Paperwork/images/RefreshIcon.png

[AppSpec]:              ./Paperwork/Udacity/UdacityAppSpecification.pdf
[CommitMsgStyleGuide]:  ./Paperwork/Udacity/UdacityGitCommitMessageStyleGuide.pdf
[GradingRubric]:        ./Paperwork/Udacity/UdacityGradingRubric.pdf
[PAPI]:                 ./Paperwork/APIs/ParseAPIOverview.pdf
[ProjectReview]:        ./Paperwork/Udacity/UdacityProjectReview.pdf
[SwiftStyleGuide]:      ./Paperwork/Udacity/GitHubSwiftStyleGuide.pdf  
[UAPI]:                 ./Paperwork/APIs/UdacityAPIOverview.pdf

[FBLicense]:            ./Paperwork/Licenses/FacebookSDK_LICENSE.txt
[FBREADME]:             ./Paperwork/Licenses/FacebookSDK_README.txt

[FBRepo]:               https://github.com/facebook/facebook-ios-sdk
[GitIgnoreRepo]:        https://github.com/github/gitignore
[PTOS]:                 https://parse.com/policies
[PWebsite]:             https://parse.com
[StyleGuideRepo]:       https://github.com/github/swift-style-guide



