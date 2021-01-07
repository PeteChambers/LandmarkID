//
//  Extension.swift
//  Landmark ID
//
//  Created by Pete Chambers on 04/01/2021.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import UIKit

extension UIImage {
    func base64EncodeImage() -> String {
            var imagedata = self.pngData()
            
            // Resize the image if it exceeds the 2MB API limit
            if ((imagedata?.count)! > 2097152) {
                let oldSize: CGSize = self.size
                let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
                imagedata = resizeImage(newSize)
            }
            
            return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
        }
    
    func resizeImage(_ imageSize: CGSize) -> Data {
            UIGraphicsBeginImageContext(imageSize)
            self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            let resizedImage = newImage!.pngData()
            UIGraphicsEndImageContext()
            return resizedImage!
        }
}
