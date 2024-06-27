//
//  LandmarkID.swift
//  Landmark ID
//
//  Created by Pete Chambers on 27/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct LandmarkID: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Landmark.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
