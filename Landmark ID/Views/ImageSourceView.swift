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
    @State private var showResults = false
    @State private var showHistory = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var landmarkTitle: String?
    @State private var landmarkDescription: String?
    @State var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if showResults {
                    VStack(alignment: .center, spacing: 10) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        }
                        if let name = landmarkTitle, let description = landmarkDescription {
                            Text(name)
                                .bold()
                            Text(description)
                            Link("More...", destination: URL(string: "https://en.wikipedia.org/wiki/\(name.replacingOccurrences(of: " ", with: "_"))")!)
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                }
                Spacer()
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Text("Choose an Image")
                        .font(.headline)
                        .foregroundColor(showResults ? .white : .blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(showResults ? .blue : .white)
                        .cornerRadius(10)
                }
                .padding()
                .onChange(of: pickerItem) {
                    Task {
                        showSpinner()
                        if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                            Task {
                                do {
                                    (landmarkTitle, landmarkDescription) = try await DataManager().createRequest(with: data.base64EncodedString())
                                    if let title = landmarkTitle, let description = landmarkDescription {
                                        let landmark = Landmark(
                                            id: UUID(),
                                            title: title,
                                            details: description,
                                            image: data
                                        )
                                        modelContext.insert(landmark)
                                        showResults = true
                                        showSuccessAlert = true
                                    }
                                } catch {
                                    showResults = false
                                    showErrorAlert = true
                                }
                            }
                        }
                       hideSpinner()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showHistory.toggle() } ) {
                        Image(systemName: "clock.fill")
                            .foregroundColor(showResults ? .blue : .white)
                    }
                }
            }
            .background {
                if !showResults {
                    Image("StPauls")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .sheet(isPresented: $showHistory) {
                LandmarkListView()
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Success!"), message: Text("Landmark saved to History"), dismissButton: .default(Text("OK")))
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("No Landmarks Found!"), message: Text("Please use a different image and try again"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func showSpinner() {
        SwiftSpinner.shared.outerColor = UIColor.white;  SwiftSpinner.setTitleColor(UIColor.white)
        SwiftSpinner.show("Analysing Image...")
    }
    
    private func hideSpinner() {
        SwiftSpinner.hide()
    }
}

#Preview {
    ImageSourceView()
}
