//
//  UIImage+Exntensions.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import CoreGraphics

//extension UIImage {
//    func resize(_ toSize: CGRect) -> UIImage {
//        let size = self.size
//        
//        let widthRatio = toSize.width / self.size.width
//        let heightRatio = toSize.height / self.size.height
//        
//        var newSize: CGSize
//        if widthRatio > heightRatio {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//        }
//        
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//        
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        self.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage!
//    }
//}

