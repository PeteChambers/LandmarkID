//
//  LoadingImages.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 05/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension LandmarkListViewController {
    
    /**
     Load all images saved by the App
    
     - parameter fetched: Completion Block for the background fetch.
     */
    
    func loadImages(_ fetched:@escaping (_ images:[Landmark]) -> Void) {
        
        
        Run.async(DispatchQueues().coreDataQueue) {
            
            guard let moc = CameraViewController().managedContext else {
                return
            }
            
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = moc
            
            privateMOC.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Const.CoreData.Landmark)
                
                do {
                    let results = try privateMOC.fetch(fetchRequest)
                    let maybeImageData = results as? [Landmark]
                    
                    guard let imageData = maybeImageData else {
                        Run.main {
                            self.noImagesFound()
                        }
                        return
                    }
                    
               
                    Run.main {
                        fetched(imageData.filter { landmark in
                            return landmark.imageData != nil && landmark.id != nil
                        })
                    }
                } catch {
                    
                    Run.main {
                        self.noImagesFound()
                    }
                    return
                }
            }
        }
    }
}
