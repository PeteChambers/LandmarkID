//
//  Datamanager.swift
//  Landmark ID
//
//  Created by Pete Chambers on 18/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import WikipediaKit
import SwiftyJSON
import SwiftSpinner


class DataManager {
    
    var googleAPIKey = "AIzaSyBUClAqYnoK5ya0jN-Yoz2OlFvyl4uPpoI"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
        
    }
    
    
    func getLandmarks() -> [Landmark]{
        var landmarks = [Landmark]()
        
        return landmarks
    }
    
    func addLandmark(id: UUID, name: String, result: String, image: UIImage) {

    }
    
    func removeLandmark(id: UUID) {

        }
    
    func saveLandmark(id: UUID, name: String, result: String, photo: Data, completion: @escaping (Bool) -> Void) {
  
        }
    
    
    func analyzeResults(_ dataToParse: Data, success: @escaping (Bool) -> Void, completion: @escaping (String, String) -> Void) {
        
        // Use SwiftyJSON to parse results
        let json = try! JSON(data: dataToParse)
        
        // Parse the response
        print(json)
        let responses: JSON = json["responses"][0]
        
        // get landmark results
        
        var landmarkResultsText:String = ""
        
        let landmarkAnnotations: JSON = responses["landmarkAnnotations"]
        
        let landmark = landmarkAnnotations[0]["description"].stringValue
        
        if !landmark.isEmpty {
            success(true)
            landmarkResultsText = landmark
            
            self.landmarkSearch(title: landmarkResultsText, completion: completion)
            
        } else {
            success(false)
        }
        
    }
    
    func createRequest(with imageBase64: String, success: @escaping (Bool) -> Void, completion: @escaping (String, String) -> Void) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
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
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data, success: success, completion: completion)
        }
        
        task.resume()

    }
    
    
    
    func landmarkSearch(title: String, completion: @escaping (String, String) -> Void) {
        
        let language = WikipediaLanguage("en")
        
        let _ = Wikipedia.shared.requestArticleSummary(language: language, title: title) { (article, error) in
            if error == nil, let article = article {
                completion(title, article.displayText)
            } else {
                completion(title, "")
            }
        }
    }
}
