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
        NavigationStack {
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
                        Link(destination: URL(string: "https://en.wikipedia.org/wiki/\(landmark.title.replacingOccurrences(of: " ", with: "_"))")!) {
                            Text("Learn more about \(landmark.title)".uppercased())
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
        let landmark = Landmark(
            id: UUID(),
            title: "London Bridge",
            details: "jfewjf wjg wrjg rwgj ergjh eorwjg rejg wrj g fewih fohr grhoh goerh geitjg oiertjget goetjo"
        )
        return LandmarkDetailView(landmark: landmark)
}
