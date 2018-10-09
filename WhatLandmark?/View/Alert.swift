//
//  Alert.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 05/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit

extension LandmarkListViewController {
        
    /**
     Display Alert when loadImages had no results
     */
    func noImagesFound() {
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let alertVC = UIAlertController(title: "No Images Found", message: "There were no images saved in Core Data", preferredStyle: .alert)
        
        alertVC.addAction(alertAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}

