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

struct ImageSourceView: View {
    @Environment(\.modelContext) var modelContext
    @Query var landmarks: [Landmark]
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var cameraImage: UIImage?
    @State private var selectedImage: UIImage?
    
    @State private var showResults = false
    @State private var showOptions = false
    @State private var showCamera = false
    @State private var showPhotosPicker = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var currentLandmark: Landmark?

    var body: some View {
        NavigationStack {
            content
                .navigationBarItems(trailing: historyButton())
                .background {
                    if !showResults {
                        backgroundImage()
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .photosPicker(isPresented: $showPhotosPicker, selection: $pickerItem, matching: .images)
                .fullScreenCover(isPresented: $showCamera) {
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
        if showResults, let landmark = currentLandmark {
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
            showOptions = true
        } label: {
            Text("Choose an image")
                .font(.headline)
                .foregroundColor(showResults ? .white : .blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(showResults ? .blue : .white)
                .cornerRadius(10)
        }
        .padding()
        .confirmationDialog("Choose an image", isPresented: $showOptions, titleVisibility: .visible) {
            Button("Take a photo") { showCamera = true }
            Button("Upload image from library") { showPhotosPicker = true }
        }
    }
    
    private func optionsButtons() -> some View {
        HStack {
            Button {
                showResults = false
            } label: {
                Text("Reset")
                    .font(.headline)
                    .foregroundColor(showResults ? .white : .blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(showResults ? .blue : .white)
                    .cornerRadius(10)
            }
            Button {
                Task {
                    await saveLandmark()
                }
            } label: {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(showResults ? .white : .blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(showResults ? .blue : .white)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
    
    private func historyButton() -> some View {
        NavigationLink {
            LandmarkListView()
        } label: {
            Image(systemName: "clock.fill")
                .foregroundColor(showResults ? .blue : .white)
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
                    currentLandmark = landmark
                    showResults = true
                }
            }
        } catch {
            await MainActor.run {
                showResults = false
                showAlert = true
                alertTitle = "No Landmarks Found!"
                alertMessage = "Please use a different image and try again"
            }
        }
    }
    
    private func saveLandmark() async {
        await MainActor.run {
            if let landmark = currentLandmark {
                modelContext.insert(landmark)
                showAlert = true
                alertTitle = "Success!"
                alertMessage = "Landmark saved to History"
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
                showAlert = true
                alertTitle = "No Network Connection!"
                alertMessage = "Please check your internet connection and try again."
            }
        }
        
        return networkAvailable
    }
}

#Preview {
    ImageSourceView()
}
