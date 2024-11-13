//
//  ImageSourceView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 26/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI

struct ImageSourceView<ViewModel: ImageSourceViewModelObservable>: View {
    
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationBarItems(trailing: historyButton())
                .background {
                    if !viewModel.showResults {
                        backgroundImage()
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text(LocalizedStrings.Buttons.ok)))
                }
                .photosPicker(isPresented: $viewModel.showPhotosPicker, selection: $viewModel.pickerItem, matching: .images)
                .fullScreenCover(isPresented: $viewModel.showCamera) {
                    CameraAccessView(selectedImage: $viewModel.cameraImage)
                        .ignoresSafeArea(.all)
                }
                .onChange(of: viewModel.pickerItem) {
                    Task {
                        await viewModel.handlePickerItemChange()
                    }
                }
                .onChange(of: viewModel.cameraImage) {
                    Task {
                        await viewModel.handleCameraImageChange()
                    }
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.showResults, let landmark = viewModel.currentLandmark {
            VStack {
                LandmarkDetailView(landmark: landmark)
            }
            Spacer()
            optionsButtons()
        } else {
            Spacer()
            selectImageButton()
        }
    }
    
    private func selectImageButton() -> some View {
        Button {
            viewModel.showOptions = true
        } label: {
            Text(LocalizedStrings.General.chooseAnImage)
                .font(.headline)
                .foregroundColor(viewModel.foregroundColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.backgroundColor)
                .cornerRadius(10)
        }
        .padding()
        .confirmationDialog(LocalizedStrings.General.chooseAnImage, isPresented: $viewModel.showOptions, titleVisibility: .visible) {
            Button(LocalizedStrings.General.takeAPhoto) { viewModel.showCamera = true }
            Button(LocalizedStrings.General.uploadImageFromLibrary) { viewModel.showPhotosPicker = true }
        }
    }
    
    private func optionsButtons() -> some View {
        HStack {
            Button {
                viewModel.showResults = false
            } label: {
                Text(LocalizedStrings.Buttons.reset)
                    .font(.headline)
                    .foregroundColor(viewModel.foregroundColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.backgroundColor)
                    .cornerRadius(10)
            }
            Button {
                viewModel.saveLandmark()
            } label: {
                Text(LocalizedStrings.Buttons.save)
                    .font(.headline)
                    .foregroundColor(viewModel.foregroundColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.backgroundColor)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
    
    private func historyButton() -> some View {
        NavigationLink {
            LandmarkListView(viewModel: LandmarkListViewModel(dataSource: .shared))
        } label: {
            Image(systemName: "clock.fill")
                .foregroundColor(viewModel.foregroundColor)
        }
    }
    
    private func backgroundImage() -> some View {
        Image("StPauls")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ImageSourceView(viewModel: ImageSourceViewModel(dataSource: .shared))
}
