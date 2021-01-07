//
//  WebService.swift
//  Landmark ID
//
//  Created by Peter Chambers on 06/01/2021.
//  Copyright © 2021 Pete Chambers. All rights reserved.
//

import Foundation
import WikipediaKit
import SwiftyJSON


protocol WebServiceProtocol : class {
    func createRequest(with imageBase64: String, success: @escaping (Bool) -> Void, completion: @escaping (String, String) -> Void)
    func landmarkSearch(title: String, completion: @escaping (String, String) -> Void)
}

class WebService: WebServiceProtocol {
    
    static let shared = WebService()
    
    // MARK: Find Landmarks

    func createRequest(with imageBase64: String, success: @escaping (Bool) -> Void, completion: @escaping (String, String) -> Void) {
        // Create request URL
        
        var request = URLRequest.getGoogleURLRequest()
        request.method = .post
        request.allHTTPHeaderFields = request.standardHeaders
        
        // Build API request
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
            do{
                let item = try JSONDecoder().decode(DataResponse.self, from: data)
                let landmark = item.responses[0].landmarkAnnotations[0].landmarkAnnotationDescription
                var landmarkResultsText:String = ""
                if !landmark.isEmpty {
                    success(true)
                    landmarkResultsText = landmark
                    self.landmarkSearch(title: landmarkResultsText, completion: completion)
                } else {
                    success(false)
                }
            } catch {
                success(false)
            }
        }
        task.resume()
    }
    
    // MARK: Search Landmarks
    // Search Wikipedia for matching page on found landmark
    
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
