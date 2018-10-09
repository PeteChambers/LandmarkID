//
//  SavingImages.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 04/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Const {
    struct CoreData {
        static let LandmarkDetail = "LandmarkDetail"
        static let Landmark = "Landmark"
    }
}

extension CameraViewController {
    
    /**
     Convert Image to JPEG and generate a thumbnail
     
     - parameter image: a captured image
     */
    func prepareImageForSaving(_ image:UIImage) {
        
        // use date as unique id
        let date : Double = Date().timeIntervalSince1970
        
        
        // dispatch with gcd.
        Run.async(DispatchQueues().imageProcessingQueue) {
            
            // create NSData from UIImage
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // scale image
        //    let thumbnail = image.scale(toSize: self.view.frame.size)
            
            guard let landmarkData  = image.jpegData(compressionQuality: 0.7) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // send to save function
            self.saveImage(imageData, landmarkData: landmarkData, date: date)
        }
    }
}

extension CameraViewController {
    
    /**
     Save image to Core Data
     
     - parameter imageData:     NSData representation of the original image
     - parameter thumbnailData: NSData representation of the thumbnail image
     - parameter date:          timestamp
     */
    func saveImage(_ imageData:Data, landmarkData:Data, date: Double) {
        
        // create new objects in moc
        Run.async(DispatchQueues().coreDataQueue) {
            guard let moc = self.managedContext else {
                return
            }
            
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = moc
            
            privateMOC.perform {
                guard let landmarkDetail = NSEntityDescription.insertNewObject(forEntityName: Const.CoreData.LandmarkDetail, into: privateMOC) as? LandmarkDetail, let landmark = NSEntityDescription.insertNewObject(forEntityName: Const.CoreData.Landmark, into: privateMOC) as? Landmark else {
                    // handle failed new object in moc
                    print("moc error")
                    return
                }
                
                //set image data of fullres
                landmarkDetail.imageData = imageData as NSData
                
                //set image data of thumbnail
                landmark.imageData = landmarkData as NSData
                landmark.id = date as NSNumber
                landmark.landmarkDetail = landmarkDetail
                
                // save the new objects
                do {
                    try privateMOC.save()
                    
                    moc.performAndWait {
                        do {
                            try moc.save()
                            moc.refreshAllObjects()
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }
}

extension CameraViewController {
    
    /**
     Delete all images saved by the App
     
     - parameter done: Completion Block for the background delete.
     */
    func deleteAllImages(_ done: @escaping () -> Void) {
        
        
        Run.async(DispatchQueues().coreDataQueue) {
            
            guard let moc = self.managedContext else {
                return
            }
            
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = moc
            
            privateMOC.performAndWait {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Const.CoreData.Landmark)
                
                do {
                    let results = try privateMOC.fetch(fetchRequest)
                    
                    for item in results {
                        if let object = item as? NSManagedObject {
                            privateMOC.delete(object)
                        }
                    }
                } catch {
                    Run.main {
                        done()
                    }
                    return
                }
                
                // save the delete op
                do {
                    try privateMOC.save()
                    
                    moc.performAndWait {
                        do {
                            try moc.save()
                            moc.refreshAllObjects()
                            Run.main {
                                done()
                            }
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
    }
}
