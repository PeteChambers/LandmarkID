//
//  ImageSourceViewModel.swift
//  Landmark ID
//
//  Created by Peter Chambers on 18/11/2020.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import UIKit

struct ImageSourceViewModel {
    
    let id: UUID
    let name: String
    let description: String
    let image: UIImage
    
    init(landmark: Landmark) {
        self.id = landmark.id ?? UUID()
        self.name = landmark.name ?? ""
        self.description = landmark.result ?? ""
        self.image = UIImage(data: landmark.photo ?? Data()) ?? UIImage()
    }
        
    init(id: UUID, name: String, description: String, image: UIImage) {
            self.id = id
            self.name = name
            self.description = description
            self.image = image
        }
    
    func saveLandmark(landmark: ImageSourceViewModel, completed: @escaping () -> Void) {
        DataManager.shared.saveLandmark(id: landmark.id, name: landmark.name, result: landmark.description, photo: landmark.image.pngData()!, completion: { success in
            completed()
        })
        
    }
    
}
