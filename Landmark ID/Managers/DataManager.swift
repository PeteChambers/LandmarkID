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
    
    
    func analyzeResults(_ dataToParse: Data) async throws -> (String, String) {
        do {
            let json = try JSON(data: dataToParse)
            
            guard let responses = json["responses"].array?.first else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No responses found"])
            }
            
            let landmarkAnnotations = responses["landmarkAnnotations"]
            if let landmark = landmarkAnnotations.array?.first?["description"].string, !landmark.isEmpty {
                return try await landmarkSearch(title: landmark)
            } else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No landmarks found"])
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
            throw error
        }
    }
    
    func createRequest(with imageBase64: String) async throws -> (String, String) {
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
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
            throw error
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
        }
        
        return try await analyzeResults(data)
    }
    
    func landmarkSearch(title: String) async throws -> (String, String) {
        let language = WikipediaLanguage("en")
        
        return try await withCheckedThrowingContinuation { continuation in
           let _ = Wikipedia.shared.requestArticleSummary(language: language, title: title) { (article, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let article = article {
                    continuation.resume(returning: (title, article.displayText))
                } else {
                    continuation.resume(throwing: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No article found"]))
                }
            }
        }
    }
}
