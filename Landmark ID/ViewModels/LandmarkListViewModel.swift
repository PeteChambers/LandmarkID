//
//  LandmarkListViewModel.swift
//  Landmark ID
//
//  Created by Peter Chambers on 18/11/2020.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import SwiftUI

protocol LandmarkListViewModelObservable: ObservableObject {
    var landmarks: [Landmark] { get set }
    func fetchLandmarks()
    func deleteLandmark(_ landmark: Landmark)
}

class LandmarkListViewModel: LandmarkListViewModelObservable {
    @Published var landmarks: [Landmark] = []
    
    private let dataSource: SwiftDataService
    
    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
        fetchLandmarks()
    }

    func fetchLandmarks() {
        landmarks = dataSource.fetchLandmarks()
    }
    
    func deleteLandmark(_ landmark: Landmark) {
        dataSource.deleteLandmark(landmark)
        fetchLandmarks()
    }
}


