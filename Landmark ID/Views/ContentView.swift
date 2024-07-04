//
//  ContentView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 27/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ImageSourceView()
        }
        .modelContext(modelContext)
    }
}
