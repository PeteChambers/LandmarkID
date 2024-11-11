//
//  ImageSourceView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 26/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import PhotosUI
import Network
import SwiftData
import SwiftSpinner
import SwiftUI

struct ImageSourceView<ViewModel: ImageSourceViewModelObservable>: View {
    
    @StateObject var viewModel: ViewModel
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var cameraImage: UIImage?
    @State private var selectedImage: UIImage?

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
                    Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                .photosPicker(isPresented: $viewModel.showPhotosPicker, selection: $pickerItem, matching: .images)
                .fullScreenCover(isPresented: $viewModel.showCamera) {
                    CameraAccessView(selectedImage: $cameraImage)
                        .ignoresSafeArea(.all)
                }
                .onChange(of: pickerItem) {
                    handlePickerItemChange()
                }
                .onChange(of: cameraImage) {
                    handleCameraImageChange()
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
            Text("Choose an image")
                .font(.headline)
                .foregroundColor(viewModel.foregroundColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.backgroundColor)
                .cornerRadius(10)
        }
        .padding()
        .confirmationDialog("Choose an image", isPresented: $viewModel.showOptions, titleVisibility: .visible) {
            Button("Take a photo") { viewModel.showCamera = true }
            Button("Upload image from library") { viewModel.showPhotosPicker = true }
        }
    }
    
    private func optionsButtons() -> some View {
        HStack {
            Button {
                viewModel.showResults = false
            } label: {
                Text("Reset")
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
                Text("Save")
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
    
    private func handlePickerItemChange() {
        Task {
            
            guard await checkNetworkConnection() else { return }
            
            await MainActor.run {
                showSpinner()
            }
            if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                await MainActor.run {
                    selectedImage = UIImage(data: data)
                }
                await analyseImage(data: data)
            }
            await MainActor.run {
                hideSpinner()
            }
            pickerItem = nil
        }
    }
    
    private func handleCameraImageChange() {
        Task {
            
            guard await checkNetworkConnection() else { return }
            
            await MainActor.run {
                showSpinner()
            }
            if let data = cameraImage?.jpegData(compressionQuality: 1.0) {
                selectedImage = cameraImage
                await analyseImage(data: data)
            }
            await MainActor.run {
                hideSpinner()
            }
        }
    }
    
    private func analyseImage(data: Data) async {
        do {
            let (title, description) = try await DataManager().detectLandmark(imageData: data)
            await MainActor.run {
                if let title = title, let description = description {
                    let landmark = Landmark(id: UUID(), title: title, details: description, image: data)
                    viewModel.currentLandmark = landmark
                    viewModel.showResults = true
                }
            }
        } catch {
            await MainActor.run {
                viewModel.showResults = false
                viewModel.showAlert = true
                viewModel.alertTitle = "No Landmarks Found!"
                viewModel.alertMessage = "Please use a different image and try again"
            }
        }
    }
    
    private func showSpinner() {
        SwiftSpinner.shared.outerColor = UIColor.white
        SwiftSpinner.setTitleColor(UIColor.white)
        SwiftSpinner.show("Analysing Image...")
    }
    
    private func hideSpinner() {
        SwiftSpinner.hide()
    }
    
    private func isNetworkAvailable() async -> Bool {
        return await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue.global(qos: .background)
            
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
                monitor.cancel()
            }
            
            monitor.start(queue: queue)
        }
    }
    
    private func checkNetworkConnection() async -> Bool {
        let networkAvailable = await isNetworkAvailable()
        
        if !networkAvailable {
            await MainActor.run {
                viewModel.showAlert = true
                viewModel.alertTitle = "No Network Connection!"
                viewModel.alertMessage = "Please check your internet connection and try again."
            }
        }
        
        return networkAvailable
    }
}

#Preview {
    ImageSourceView(viewModel: ImageSourceViewModel(dataSource: .shared))
}
