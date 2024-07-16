//
//  Datamanager.swift
//  Landmark ID
//
//  Created by Pete Chambers on 18/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

enum WikipediaError: Error {
    case invalidURL
    case noData
    case invalidResponse
}

enum LandmarkError: Error {
    case noLandmarkDetected
}

class DataManager {
    
    private let searchBaseURL = "https://en.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch="
    private let summaryBaseURL = "https://en.wikipedia.org/api/rest_v1/page/summary/"
    private let googleAPIKey = "AIzaSyBUClAqYnoK5ya0jN-Yoz2OlFvyl4uPpoI"
    
    private var googleURL: URL {
        URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    func detectLandmark(imageData: Data) async throws -> (String?, String?) {
        let requestPayload: [String: Any] = [
            "requests": [
                [
                    "image": ["content": imageData.base64EncodedString()],
                    "features": [["type": "LANDMARK_DETECTION", "maxResults": 1]]
                ]
            ]
        ]
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestPayload, options: [])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSON(data: data)
        
        if let landmark = json["responses"][0]["landmarkAnnotations"][0]["description"].string {
            let summary = try await fetchSummaryWithFallback(for: landmark)
            return (landmark, summary)
        }
        
        throw LandmarkError.noLandmarkDetected
    }
    
    private func fetchWikipediaSummary(for article: String) async throws -> String {
        let urlString = summaryBaseURL + article.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        
        guard let url = URL(string: urlString) else {
            throw WikipediaError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
            throw WikipediaError.noData
        }
        
        let json = try JSON(data: data)
        
        if let extract = json["extract"].string {
            return extract
        } else {
            throw WikipediaError.invalidResponse
        }
    }

    private func searchWikipedia(for query: String) async throws -> String {
        let urlString = searchBaseURL + query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: urlString) else {
            throw WikipediaError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let json = try JSON(data: data)
        
        if let title = json["query"]["search"].array?.first?["title"].string {
            return title
        } else {
            throw WikipediaError.noData
        }
    }

    private func fetchSummaryWithFallback(for query: String) async throws -> String {
        do {
            return try await fetchWikipediaSummary(for: query)
        } catch WikipediaError.noData {
            let title = try await searchWikipedia(for: query)
            return try await fetchWikipediaSummary(for: title)
        }
    }
}
