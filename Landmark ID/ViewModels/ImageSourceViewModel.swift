//
//  ImageSourceViewModel.swift
//  Landmark ID
//
//  Created by Pete Chambers on 11/11/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import Network
import PhotosUI
import SwiftSpinner
import SwiftUI

@MainActor
protocol ImageSourceViewModelObservable: ObservableObject {
    var currentLandmark: Landmark? { get set }
    var showResults: Bool { get set }
    var showAlert: Bool { get set }
    var showOptions: Bool { get set }
    var showCamera: Bool { get set }
    var showPhotosPicker: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    
    var pickerItem: PhotosPickerItem? { get set }
    var cameraImage: UIImage? { get set }
    
    var foregroundColor: Color { get }
    var backgroundColor: Color { get }
    func handlePickerItemChange() async
    func handleCameraImageChange() async
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
    @Published var pickerItem: PhotosPickerItem?
    @Published var cameraImage: UIImage?
    
    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
    }
    
    var foregroundColor: Color {
        showResults ? .white : .blue
    }
    
    var backgroundColor: Color {
        showResults ? .blue : .white
    }
    
    func handlePickerItemChange() async {
        await processImageData {
            try await pickerItem?.loadTransferable(type: Data.self)
        }
        pickerItem = nil
    }
    
    func handleCameraImageChange() async {
        await processImageData {
            cameraImage?.jpegData(compressionQuality: 1.0)
        }
    }
    
    func saveLandmark() {
        if let landmark = currentLandmark {
            dataSource.saveLandmark(landmark)
            showAlert = true
            alertTitle = LocalizedStrings.Alerts.success
            alertMessage = LocalizedStrings.Alerts.successDescription
        }
    }
    
    func analyseImage(data: Data) async {
        do {
            let (title, description) = try await DataManager().detectLandmark(imageData: data)
            if let title = title, let description = description {
                let landmark = Landmark(id: UUID(), title: title, details: description, image: data)
                currentLandmark = landmark
                showResults = true
            }
        } catch {
            showResults = false
            showAlert = true
            alertTitle = LocalizedStrings.Alerts.noLandmarksFound
            alertMessage = LocalizedStrings.Alerts.noLandmarksFoundDescription
        }
    }
    
    private func processImageData(from dataProvider: () async throws -> Data?) async {
        guard await checkNetworkConnection() else { return }
        
        showSpinner()
        if let data = try? await dataProvider() {
            await analyseImage(data: data)
        }
        hideSpinner()
    }
    
    private func checkNetworkConnection() async -> Bool {
        let networkAvailable = await isNetworkAvailable()
        
        if !networkAvailable {
            showAlert = true
            alertTitle = LocalizedStrings.Alerts.noNetworkConnection
            alertMessage = LocalizedStrings.Alerts.noNetworkConnectionDescription
        }
        
        return networkAvailable
    }
    
    private func isNetworkAvailable() async -> Bool {
        return await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue.global(qos: .background)
            
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
                monitor.cancel()
            }
            
            monitor.start(queue: queue)
        }
    }
    
    private func showSpinner() {
        SwiftSpinner.shared.outerColor = UIColor.white
        SwiftSpinner.setTitleColor(UIColor.white)
        SwiftSpinner.show(LocalizedStrings.General.analyzingImage)
    }
    
    private func hideSpinner() {
        SwiftSpinner.hide()
    }
}
