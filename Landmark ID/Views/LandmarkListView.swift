//
//  LandmarkListView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 26/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI

struct LandmarkListView<ViewModel: LandmarkListViewModelObservable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            ForEach(viewModel.landmarks) { landmark in
                HStack {
                    if let imageData = landmark.image {
                        Image(uiImage: UIImage(data: imageData)!)
                    }
                    Text(landmark.name)
                }
            }
        }
        .navigationTitle("History")
        .onAppear {
            viewModel.requestFetchLandmarks()
        }
    }
}

#Preview {
    LandmarkListView(viewModel: LandmarkListViewModel())
}
