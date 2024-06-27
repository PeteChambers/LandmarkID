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
    @State private var selectedImage: Image?
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center, spacing: 10) {
                    selectedImage?
                        .resizable()
                        .scaledToFit()
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
                        selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
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
                Image("StPauls")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
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
