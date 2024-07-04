//
//  LandmarkListView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 26/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftData
import SwiftUI

struct LandmarkListView: View {
        
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query var landmarks: [Landmark]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(landmarks) { landmark in
                    HStack {
                        if let imageData = landmark.image {
                            Image(uiImage: UIImage(data: imageData)!)
                        }
                        Text(landmark.title)
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Dismiss") {
                dismiss()
            })
        }
    }
}
