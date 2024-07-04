//
//  LandmarkDataSource.swift
//  Landmark ID
//
//  Created by Pete Chambers on 04/07/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftData

final class LandmarkDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = LandmarkDataSource()

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Landmark.self)
        self.modelContext = modelContainer.mainContext
    }

    func saveLandmark(_ landmark: Landmark) {
        modelContext.insert(landmark)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchLandmark() -> [Landmark] {
        do {
            return try modelContext.fetch(FetchDescriptor<Landmark>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func deleteLandmark(_ landmark: Landmark) {
        modelContext.delete(landmark)
    }
    
}
