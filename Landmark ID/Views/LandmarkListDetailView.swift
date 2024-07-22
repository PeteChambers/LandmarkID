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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                if let imageData = landmark.image {
                    Image(uiImage: UIImage(data: imageData)!)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
                }
                VStack(alignment: .leading, spacing: 20) {
                    Text(landmark.title)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Text(landmark.details)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    GroupBox() {
                        HStack {
                            Text(landmark.title)
                            Spacer()
                            Link("Wikipedia", destination: URL(string: "https://en.wikipedia.org/wiki/\(landmark.title.replacingOccurrences(of: " ", with: "_"))")!)
                            Image(systemName: "arrow.up.right.square")
                        }
                        .font(.footnote)
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
