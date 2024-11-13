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
    var landmarkToDelete: Landmark? { get set }
    var showDeleteAlert: Bool { get set }
    var isEditing: Bool { get set }
    func fetchLandmarks()
    func setItemToDelete(_ landmark: Landmark?)
    func deleteLandmark(_ landmark: Landmark)
}

class LandmarkListViewModel: LandmarkListViewModelObservable {
    
    @Published var landmarks: [Landmark] = []
    @Published var landmarkToDelete: Landmark?
    @Published var isEditing: Bool = false
    @Published var showDeleteAlert: Bool = false
    
    private let dataSource: SwiftDataService
    
    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
        fetchLandmarks()
    }

    func fetchLandmarks() {
        landmarks = dataSource.fetchLandmarks()
    }
    
    func deleteLandmark(_ landmark: Landmark) {
        if let index = landmarks.firstIndex(of: landmark) {
            dataSource.deleteLandmark(landmarks[index])
            fetchLandmarks()
        }
    }
    
    func setItemToDelete(_ landmark: Landmark?) {
        landmarkToDelete = landmark
        showDeleteAlert = landmark != nil
    }
}


