//
//  LandmarkListViewModel.swift
//  Landmark ID
//
//  Created by Peter Chambers on 18/11/2020.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import Foundation
import CoreData

class LandmarkListViewModel : BaseViewModel  {
    var landmarks = [ImageSourceViewModel]()
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return self.landmarks.count
    }
    
    func fetchAllLandmarks() {
        landmarks = DataManager.shared.getLandmarks().map(ImageSourceViewModel.init)
    }
    
    func saveLandmark(landmark: ImageSourceViewModel, completed: @escaping () -> Void) {
        dataManager.saveLandmark(id: landmark.id, name: landmark.name, result: landmark.description, photo: landmark.image.pngData()!, completion: { success in
            completed()
        })
        
    }
    
    func removeLandmark(at index: Int) {
        let landmark = self.landmarks[index]
        dataManager.removeLandmark(id: landmark.id)
    }
    
    func identifyLandmark(imageData: String, success: @escaping (Bool) -> Void, completion: @escaping (String, String) -> Void) {
        webService.createRequest(with: imageData, success: success, completion: completion)
    }
}


