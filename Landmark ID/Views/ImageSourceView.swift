//
//  ImageSourceView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 26/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftData
import SwiftUI
import PhotosUI

struct ImageSourceView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var landmarks: [Landmark]
    @State private var pickerItem: PhotosPickerItem?
    @State private var showResults = false
    @State private var showHistory = false
    @State private var showAlert = false
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
                            Text(description)
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                }
                Spacer()
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Text("Choose an Image")
                        .font(.headline)
                        .foregroundColor(showResults ? .blue : .white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(showResults ? .white : .blue)
                        .cornerRadius(10)
                }
                .padding()
                .onChange(of: pickerItem) {
                    Task {
                        if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                            Task {
                                do {
                                    (landmarkTitle, landmarkDescription) = try await DataManager().createRequest(with: data.base64EncodedString())
                                    let landmark = Landmark(
                                        id: UUID(),
                                        title: landmarkTitle ?? "",
                                        details: landmarkDescription ?? "",
                                        image: data
                                    )
                                        modelContext.insert(landmark)

                                } catch {
                                    showAlert.toggle()
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showHistory.toggle() } ) {
                        Image(systemName: "clock.fill")
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
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("No Landmarks Found!"), message: Text("Please use a different image and try again"), dismissButton: .default(Text("OK")))
        }
    }
    
    func updateLandmark(title: String, description: String) async {
        landmarkTitle = title
        landmarkDescription = description
    }
}

#Preview {
    ImageSourceView()
}
