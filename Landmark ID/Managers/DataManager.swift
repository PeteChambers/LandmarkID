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

protocol DataManagerProtocol : class {
    func getLandmarks() -> [Landmark]
    func addLandmark(id: UUID, name: String, result: String, image: UIImage)
    func removeLandmark(id: UUID)
    func saveLandmark(id: UUID, name: String, result: String, photo: Data, completion: @escaping (Bool) -> Void)
}


class DataManager : DataManagerProtocol {
    
    // shared instance
    
    static let shared = DataManager(moc: NSManagedObjectContext.current)
        var managedContext: NSManagedObjectContext
        private init(moc: NSManagedObjectContext) {
            self.managedContext = moc
        }
    
    // MARK: Get Landmarks
    
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
    
    // MARK: Add Landmark
    
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
    
    // MARK: Remove Landmark
    
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
    
    // MARK: Save Landmarks
    
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
    
}

extension NSManagedObjectContext {
    static var current: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}

