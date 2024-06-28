//
//  ImageSourceView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 26/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//


import SwiftUI
import PhotosUI

struct ImageSourceView<ViewModel: ImageSourceViewModelObservable>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    @State private var pickerItem: PhotosPickerItem?
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center, spacing: 10) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                    if let name = viewModel.landmarkName, let description = viewModel.landmarkDescription {
                        Text(name)
                        Text(description)
                    }
                }
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                Spacer()
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Text("Choose an Image")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding()
                .onChange(of: pickerItem) {
                    Task {
                        if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                            viewModel.selectedImage = UIImage(data: data)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "clock.fill")
                    }
                }
            }
            .background {
                if !viewModel.showResults {
                    Image("StPauls")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .sheet(isPresented: $viewModel.showHistory) {
                LandmarkListView(viewModel: LandmarkListViewModel())
            }
        }
    }
}

#Preview {
    ImageSourceView(viewModel: ImageSourceViewModel())
}
