//
//  ImageSourceViewModel.swift
//  Landmark ID
//
//  Created by Peter Chambers on 18/11/2020.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import UIKit
import SwiftUI

protocol ImageSourceViewModelObservable: ObservableObject {
    var showHistory: Bool { get set }
    var showResults: Bool { get set }
    var selectedImage: UIImage? { get set }
    var landmarkName: String? { get }
    var landmarkDescription: String? { get }
}

class ImageSourceViewModel: ImageSourceViewModelObservable, Identifiable {
    
    let dataManager = DataManager()
    
    @Published var showHistory: Bool = false
    @Published var showResults: Bool = false
    @Published var landmarkName: String?
    @Published var landmarkDescription: String?
    
    @Published var selectedImage: UIImage? {
        didSet {
            showResults = true
            if let data = selectedImage?.jpegData(compressionQuality: 1.0) {
                let imageData = data.base64EncodedString(options: .lineLength64Characters)
                identifyLandmark(imageData: imageData) { success in
                    DispatchQueue.main.async {
                        self.showResults = success
                    }
                } completion: { name, description in
                    DispatchQueue.main.async {
                        self.landmarkName = name
                        self.landmarkDescription = description
                    }
                }
            }
        }
    }
    
    func identifyLandmark(imageData: String, success: @escaping (Bool) -> Void, completion: @escaping (String, String) -> Void) {
        dataManager.createRequest(with: imageData, success: success, completion: completion)
    }
}
