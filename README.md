# Landmark ID

Landmark ID is a photo recongnition app that uses the Google Cloud Vision API to determine the lanmarks present in a users photo.  Users are able to take or upload a photo and Landmark ID will do the rest.

- Automatic saving of your landmarks to the app
- Read up to date information about the landmark inluding name, location, history and more

### Prerequisites

Download the libraries displayed below from CocoaPods to use this app.

##### CocoaPods

1. Make sure CocoaPods is installed.
- CocoaPods - The application level dependency manager used
Update your Podfile to include the following:


`pod 'SwiftyJSON', '~> 4.0'`

`pod "SwiftSpinner"`

3. Run pod install.

##### Google Cloud API

- obtain your own Google API key and add it to "GoogleCloudVision.swift":

`static var googleAPIKey = "YOUR_API_HERE"`

- Add your client_id and client_secret values to the p.list file

### Running the app

Open stalkerapp.xcodeproj with xcode 9.0. you can either install in an iOS device or running the project in the simulator.

### How To use




