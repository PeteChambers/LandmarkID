# Landmark ID

Landmark ID is a photo recongnition app that uses the Google Cloud Vision API to determine the lanmarks present in a users photo.  Users are able to take or upload a photo and Landmark ID will do the rest.

- Automatic saving of your landmarks to the app
- Read up to date information about the landmark inluding name, location, history and more

### Prerequisites

Download the libraries displayed below from CocoaPods to use this app.

##### CocoaPods

-  Make sure CocoaPods is installed.

- CocoaPods - The application level dependency manager used
Update your Podfile to include the following:


`pod 'SwiftyJSON', '~> 4.0'`

`pod "SwiftSpinner"`

- Run pod install.

##### Google Cloud API

- obtain your own Google API key and add it to "GoogleCloudVision.swift":

`static var googleAPIKey = "YOUR_API_HERE"`

- Add your client_id and client_secret values to the p.list file

### Running the app

Open LandmarkID.xcodeproj with xcode. you can either install in an iOS device or running the project in the simulator.

### User Interface

The user interface is made up of 4 viewcontrollers:

- ImageSourceViewController
- LandmarkListViewController
- LandmarkDetailViewController
- WebViewController

#### ImageSourceViewConteroller

- Use the 'Choose an Image' button at the bottom of the screen to select an image from the photo library or take one using the inbuilt camera

<img width="300" alt="screenshot 2018-11-07 at 15 40 06" src="https://user-images.githubusercontent.com/28652344/48146071-218de600-e2ac-11e8-93c4-4577aae29a7d.png">

##### Image Analysis

- Once the image is selected the Google Vision API will start analysing the image, this will only take a few seconds

<img width="296" alt="screenshot 2018-11-07 at 15 42 09" src="https://user-images.githubusercontent.com/28652344/48146203-5c901980-e2ac-11e8-8601-838011f417a6.jpeg">



##### Automatic saving

- Once the image has been analysed and a match found, the name of the landmark and its descroption will appear including a prompt to tell the user that the information has been saved to History located in LandmarkListViewController

<img width="296" alt="screenshot 2018-11-07 at 15 41 34" src="https://user-images.githubusercontent.com/28652344/48143485-cc030a80-e2a6-11e8-8d74-63ceb8e6bf09.jpeg">

#### LandmarkListViewController

- Tapping the 'bookmark' icon in the top right of ImageSourceViewController segues to LandmarlListViewController which contains the user's History

- History displays all the landmarks that have been successfully matched to user images.  If no landmarks have been found, the tableView will be empty

<img width="296" alt="screenshot 2018-11-07 at 16 20 15" src="https://user-images.githubusercontent.com/28652344/48144624-23a27580-e2a9-11e8-9102-a88752657bf4.png">

- The edit button enables the user to delete any unwanted landmarks that have been saved, alternatively swipe to delete can be used.

<img width="296" alt="screenshot 2018-11-07 at 15 43 22" src="https://user-images.githubusercontent.com/28652344/48142840-7bd77880-e2a5-11e8-9fc4-0b7af5405566.png">

#### LandmarkDetailViewController

- Tapping on any of the saved Landmarks will segue to LandmarkDetailViewContoller containing a detailed view of the image, its name and description

- clicking on the 'More' button located at the bottom will segue to user to WebViewController

<img width="295" alt="screenshot 2018-11-07 at 15 43 43" src="https://user-images.githubusercontent.com/28652344/48142839-7bd77880-e2a5-11e8-8bc0-19a4891f73fa.png">

#### WebViewController

- Tapping on the 'More' button on either ImageSourceViewController or LandmarkDetailViewController will segue to WebViewController

- WebViewController contains a webview and performs a Wikipedia search of the selected landmark to give the user further imformation about it.

<img width="296" alt="screenshot 2018-11-07 at 15 44 16" src="https://user-images.githubusercontent.com/28652344/48142837-7bd77880-e2a5-11e8-9587-68ffed9cbc8c.png">






