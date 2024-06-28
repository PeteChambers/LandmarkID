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
        do {
            // Use SwiftyJSON to parse results
            let json = try JSON(data: dataToParse)
            
            // Parse the response
            print(json)
            guard let responses = json["responses"].array?.first else {
                success(false)
                return
            }
            
            // Get landmark results
            let landmarkAnnotations = responses["landmarkAnnotations"]
            if let landmark = landmarkAnnotations.array?.first?["description"].string, !landmark.isEmpty {
                success(true)
                landmarkSearch(title: landmark, completion: completion)
            } else {
                success(false)
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
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
        let jsonRequest: [String: Any] = [
            "requests": [
                [
                    "image": [
                        "content": imageBase64
                    ],
                    "features": [
                        [
                            "type": "LANDMARK_DETECTION",
                            "maxResults": 10
                        ]
                    ]
                ]
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonRequest)
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with request: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
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
