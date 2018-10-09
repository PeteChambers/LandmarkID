//
//  Landmark-UIImage.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 05/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit

extension Landmark {
    
    /// Convenience Property to get set the imageDate with a UIImage
    var image : UIImage? {
        get {
            if let imageData = imageData {
                return UIImage(data: imageData as Data)
            }
            return nil
        }
        set(value) {
            if let value = value {
                imageData = image?.jpegData(compressionQuality: 0.7) as NSData?
            }
        }
    }
}
