//
//  ImageSourceView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 26/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import PhotosUI
import SwiftData
import SwiftSpinner
import SwiftUI

struct ImageSourceView: View {
    @Environment(\.modelContext) var modelContext
    @Query var landmarks: [Landmark]
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    @State private var showResults = false
    @State private var showOptions = false
    @State private var showCamera = false
    @State private var showPhotosPicker = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    
    @State private var landmarkTitle: String?
    @State private var landmarkDescription: String?

    var body: some View {
        NavigationView {
            content
                .navigationBarItems(trailing: historyButton())
                .background {
                    if !showResults {
                        backgroundImage()
                    }
                }
                .alert(isPresented: $showSuccessAlert) {
                    Alert(title: Text("Success!"), message: Text("Landmark saved to History"), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("No Landmarks Found!"), message: Text("Please use a different image and try again"), dismissButton: .default(Text("OK")))
                }
                .photosPicker(isPresented: $showPhotosPicker, selection: $pickerItem, matching: .images)
                .fullScreenCover(isPresented: $showCamera) {
                    CameraAccessView(selectedImage: $selectedImage)
                        .ignoresSafeArea(.all)
                }
                .onChange(of: pickerItem) {
                    handlePickerItemChange()
                }
                .onChange(of: selectedImage) {
                    handleSelectedImageChange()
                }
        }
    }
    
    private var content: some View {
        VStack {
            if showResults, let image = selectedImage {
                resultView(image: image)
            }
            Spacer()
            selectImageButton()
        }
    }
    
    private func resultView(image: UIImage) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Image(uiImage: image)
                .resizable()
                .frame(height: UIScreen.main.bounds.height / 2 )
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            if let name = landmarkTitle, let description = landmarkDescription {
                Text(name).bold()
                Text(description)
                Link("More...", destination: URL(string: "https://en.wikipedia.org/wiki/\(name.replacingOccurrences(of: " ", with: "_"))")!)
            }
        }
        .multilineTextAlignment(.center)
        .padding()
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
    
    private func handleSelectedImageChange() {
        Task {
            await MainActor.run {
                showSpinner()
            }
            if let data = selectedImage?.jpegData(compressionQuality: 1.0) {
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
                landmarkTitle = title
                landmarkDescription = description
                if let title = landmarkTitle, let description = landmarkDescription {
                    let landmark = Landmark(id: UUID(), title: title, details: description, image: data)
                    modelContext.insert(landmark)
                    showResults = true
                    showSuccessAlert = true
                }
            }
        } catch {
            await MainActor.run {
                showResults = false
                showErrorAlert = true
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
}

#Preview {
    ImageSourceView()
}
