//
//  ImageSourceViewModel.swift
//  Landmark ID
//
//  Created by Pete Chambers on 11/11/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI

protocol ImageSourceViewModelObservable: ObservableObject {
    var currentLandmark: Landmark? { get set }
    var showResults: Bool { get set }
    var showAlert: Bool { get set }
    var showOptions: Bool { get set }
    var showCamera: Bool { get set }
    var showPhotosPicker: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    var foregroundColor: Color { get }
    var backgroundColor: Color { get }
    func saveLandmark()
    func analyseImage(data: Data) async
}

class ImageSourceViewModel: ImageSourceViewModelObservable {
    
    private let dataSource: SwiftDataService
    
    @Published var currentLandmark: Landmark?
    @Published var showResults: Bool = false
    @Published var showOptions: Bool = false
    @Published var showCamera: Bool = false
    @Published var showPhotosPicker: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
    }
    
    var foregroundColor: Color {
        showResults ? .white : .blue
    }
    
    var backgroundColor: Color {
        showResults ? .blue : .white
    }
    
    func saveLandmark() {
        if let landmark = currentLandmark {
            dataSource.saveLandmark(landmark)
            showAlert = true
            alertTitle = "Success!"
            alertMessage = "Landmark saved to History"
        }
    }
    
    func analyseImage(data: Data) async {
        do {
            let (title, description) = try await DataManager().detectLandmark(imageData: data)
            await MainActor.run {
                if let title = title, let description = description {
                    let landmark = Landmark(id: UUID(), title: title, details: description, image: data)
                    currentLandmark = landmark
                    showResults = true
                }
            }
        } catch {
            await MainActor.run {
                showResults = false
                showAlert = true
                alertTitle = "No Landmarks Found!"
                alertMessage = "Please use a different image and try again"
            }
        }
    }
}
