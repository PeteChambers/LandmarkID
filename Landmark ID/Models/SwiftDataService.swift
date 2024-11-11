//
//  SwiftDataService.swift
//  Landmark ID
//
//  Created by Pete Chambers on 11/11/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftData
import SwiftUI

class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Landmark.self)
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchLandmarks() -> [Landmark] {
        do {
            return try modelContext.fetch(FetchDescriptor<Landmark>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func saveLandmark(_ landmark: Landmark) {
        modelContext.insert(landmark)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteLandmark(_ landmark: Landmark) {
        modelContext.delete(landmark)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
