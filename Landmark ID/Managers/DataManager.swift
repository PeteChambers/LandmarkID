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
    
    static let shared = DataManager(moc: NSManagedObjectContext.current)
        
        var managedContext: NSManagedObjectContext
        
        private init(moc: NSManagedObjectContext) {
            self.managedContext = moc
        }
    
    func getLandmarks() -> [Landmark]{
        var landmarks = [Landmark]()
        let bdRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()
        
        do {
            landmarks = try self.managedContext.fetch(bdRequest)
        } catch {
            print(error)
        }
        
        return landmarks
    }
    
    func addLandmark(id: UUID, name: String, result: String, image: UIImage) {
        let landmarkEntity = NSEntityDescription.insertNewObject(forEntityName: "Landmark", into: managedContext) as! Landmark
        landmarkEntity.setValue(id, forKey: "id")
        landmarkEntity.setValue(name, forKey: "name")
        landmarkEntity.setValue(result, forKey: "result")
        let data = NSData(data: image.jpegData(compressionQuality: 0.3)!)
        landmarkEntity.setValue(data, forKey: "photo")
        do {
            try self.managedContext.save()
        } catch {
            print(error)
        }
    }
    
    func removeLandmark(id: UUID) {
            let fetchRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "id=%@", id.uuidString)
            do {
                let landmarks = try self.managedContext.fetch(fetchRequest)
                for landmark in landmarks {
                    self.managedContext.delete(landmark)
                }
                try self.managedContext.save()
            } catch {
              print(error)
            }
        }
    
    func saveLandmark(id: UUID, name: String, result: String, photo: Data, completion: @escaping (Bool) -> Void) {
            let landmark = Landmark(context: self.managedContext)
            landmark.id = id
            landmark.name = name
            landmark.result = result
            landmark.photo = photo
            do {
                try self.managedContext.save()
                completion(true)
            } catch {
                print(error)
            }
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

extension NSManagedObjectContext {
    static var current: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
