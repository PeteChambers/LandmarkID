//
//  Landmark.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit



struct TempLandmark {
    
    // MARK: Properties
    
    let name: String
    let image: String
    
    static let NameKey = "NameKey"
    static let ImageKey = "ImageKey"
    
    
    init(dictionary: [String : String]) {
        
        self.name = dictionary[TempLandmark.NameKey]!
        self.image = dictionary[TempLandmark.ImageKey]!
    }
}



extension TempLandmark {
    
    // Generate an array full of all of the villains in
    static var allLandmarks: [TempLandmark] {
        
        var landmarkArray = [TempLandmark]()
        
        for d in TempLandmark.localTempLandmarkData() {
            landmarkArray.append(TempLandmark(dictionary: d))
        }
        
        return landmarkArray
    }
    
    static func localTempLandmarkData() -> [[String : String]] {
        return [
            [TempLandmark.NameKey : "Big Ben",  TempLandmark.ImageKey : "Ben"],
            [TempLandmark.NameKey : "Statue of Liberty", TempLandmark.ImageKey : "Liberty"],
            [TempLandmark.NameKey : "Roman Colosseum", TempLandmark.ImageKey : "Colosseum"],
            
        ]
    }
}
