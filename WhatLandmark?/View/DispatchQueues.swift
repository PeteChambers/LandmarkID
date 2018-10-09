//
//  DispatchQueues.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 05/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit

struct DispatchQueues {
    
    /// A dispatch queue to convert images to jpeg and to thumbnail size
    let imageProcessingQueue = DispatchQueue(label: "imageProcessingQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// A dispatch queue for the Core Data managed context
    let coreDataQueue = DispatchQueue(label: "coreDataQueue")

    
}
