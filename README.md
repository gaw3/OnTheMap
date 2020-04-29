# ![][AppIcon]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OnTheMap

OnTheMap allows a Udacity student to share his location, and a URL of interest, with other students.  The locations specified in the 100 most-recent student postings are presented as pins on a map or as items in a table.  The student postings database is hosted on a Udacity server using a local copy of Parse.

## Project

OnTheMap is Portfolio Project #3 of the Udacity iOS Developer Nanodegree Program.  The following list contains pertinent course documents:

* [Udacity App Specification][AppSpec]
* [Udacity Grading Rubric][GradingRubric]
* [GitHub Swift Style Guide][SwiftStyleGuide]
* [Udacity Git Commit Message Style Guide][CommitMsgStyleGuide]
* [Udacity Project Review][ProjectReview]<br/><br/>

| [Change Log][ChangeLog] | Current Build          | Project Submission - ***Exceeds Expectations*** |
| :----------             | :-----------------     | :-------------                                  |
| GitHub Tag              | v2.1                   | v1.1                                            |
| App Version:            | 2.1                    | 1.1                                             |
| Environment:            | iOS 13.4 / Swift 5     | iOS 9.2 / Swift 2                               |
| Devices:                | iPhone Only            | iPhone Only                                     |
| Orientations:           | Portrait Only          | Portrait Only                                   |

## Design - discussion is forthcoming GW 4/29/2020

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

* *GitHub Swift Style Guide* lives in this [repo][StyleGuideRepo].
* `Swift.gitignore`, the template used to create the local `.gitignore` file, lives in this [repo][GitIgnoreRepo].

---
**Copyright © 2016-2020 Gregory White. All rights reserved.**





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



