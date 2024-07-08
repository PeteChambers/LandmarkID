//
//  LandmarkListDetailView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 08/07/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI

struct LandmarkDetailView: View {
    var landmark: Landmark
    
    var body: some View {
        VStack {
            if let imageData = landmark.image {
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding()
            }
            Text(landmark.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text(landmark.details)
                .padding()
            Link("More...", destination: URL(string: "https://en.wikipedia.org/wiki/\(landmark.title.replacingOccurrences(of: " ", with: "_"))")!)
            Spacer()
        }
        .navigationTitle(landmark.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
