//
//  LandmarkListViewModel.swift
//  Landmark ID
//
//  Created by Peter Chambers on 18/11/2020.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import Foundation
import SwiftData
import SwiftUI

protocol LandmarkListViewModelObservable: ObservableObject {
    func requestFetchLandmarks()
}

class LandmarkListViewModel: LandmarkListViewModelObservable {
    
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func requestFetchLandmarks() {
        fetchAllLandmarks()
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return 0
    }
    
    func fetchAllLandmarks() {
        
    }
    
    func removeLandmark(at index: Int) {
//        let landmark = self.landmarks[index]
//        DataManager.shared.removeLandmark(id: landmark.id)
    }
    
    func identifyLandmark(imageData: String, success: @escaping (Bool) -> Void, completion: @escaping (String, String) -> Void) {
//        DataManager.shared.createRequest(with: imageData, success: success, completion: completion)
    }
}


