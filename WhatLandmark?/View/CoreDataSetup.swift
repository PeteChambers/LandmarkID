//
//  CoreDataSetup.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 04/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import CoreData
import UIKit


extension CameraViewController {
    
    /**
     Start Core Data managed context on the correct queue
     */
    func coreDataSetup() {
        Run.sync(DispatchQueues().coreDataQueue) {
            self.managedContext = AppDelegate().managedObjectContext
        }
        
    }
}
