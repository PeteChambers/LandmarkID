//
//  DataController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 18/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { ( storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}


// MARK: - Autosaving

//extension DataController {
//    func autoSaveViewContext(interval:TimeInterval = 30) {
//        print("autosaving")
//
//        guard interval > 0 else {
//            print("cannot set negative autosave interval")
//            return
//        }
//
//        if viewContext.hasChanges {
//            try? viewContext.save()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
//            self.autoSaveViewContext(interval: interval)
//        }
//    }
//}
