//
//  GoogleCloudVision.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 27/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import SwiftyJSON


class GoogleCloudVision: SharedImagePickerController {
    
    
    static var googleAPIKey = "AIzaSyBUClAqYnoK5ya0jN-Yoz2OlFvyl4uPpoI"
    static var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
        
    }
    
}

extension ResultsViewController {
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = try! JSON(data: dataToParse)
            self.activityIndicator.stopAnimating()
            self.image_from_library.isHidden = true
            self.landmarkResults.isHidden = false
            
            
            // Check for errors
            
            // Parse the response
            print(json)
            let responses: JSON = json["responses"][0]
            
            // get landmark results
            let landmarkAnnotations: JSON = responses["landmarkAnnotations"]
            let numLandmarks: Int = landmarkAnnotations.count
            var landmarks: Array<String> = []
            if numLandmarks > 0 {
                var landmarkResultsText:String = "Landmarks found: "
                for index in 0..<numLandmarks {
                    let landmark = landmarkAnnotations[index]["description"].stringValue
                    landmarks.append(landmark)
                }
                for landmark in landmarks {
                    // if it's not the last item add a comma
                    if landmarks[landmarks.count - 1] != landmark {
                        landmarkResultsText += "\(landmark), "
                    } else {
                        landmarkResultsText += "\(landmark)"
                    }
                }
                self.landmarkResults.text = landmarkResultsText
            } else {
                self.landmarkResults.text = "No landmarks found"
            }
        })
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    
    /// Networking
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        
        // Resize the image if it exceeds the 2MB API limit
        if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: GoogleCloudVision.googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LANDMARK_DETECTION",
                        "maxResults": 10
                    ],
                    
                ]
            ]
        ]
        let jsonObject = JSON(jsonRequest)
        print(jsonRequest)
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
    
}
