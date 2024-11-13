//
//  LandmarkListView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 26/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftData
import SwiftUI

struct LandmarkListView<ViewModel: LandmarkListViewModelObservable>: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Group {
            if viewModel.landmarks.isEmpty {
                ContentUnavailableView(
                    LocalizedStrings.Alerts.noSavedLandmarks,
                    systemImage: "photo",
                    description: Text(LocalizedStrings.Alerts.noSavedLandmarksDescription))
            } else {
                List {
                    ForEach(viewModel.landmarks) { landmark in
                        HStack {
                            if viewModel.isEditing {
                                Button(action: {
                                    viewModel.setItemToDelete(landmark)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            NavigationLink(destination: LandmarkDetailView(landmark: landmark)) {
                                HStack {
                                    if let imageData = landmark.image {
                                        Image(uiImage: UIImage(data: imageData)!)
                                            .landmarkImageModifier()
                                    } else {
                                        Image(systemName: "photo")
                                            .landmarkImageModifier()
                                    }
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(landmark.title)
                                            .lineLimit(2)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Text(landmark.details)
                                            .lineLimit(2)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .transaction { transaction in
                                        transaction.animation = nil
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(LocalizedStrings.General.history)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            withAnimation {
                viewModel.isEditing.toggle()
            }
        }) {
            Text(viewModel.isEditing ? LocalizedStrings.Buttons.done : LocalizedStrings.Buttons.edit)
        }
        .disabled(viewModel.landmarks.isEmpty))
        .environment(\.editMode, viewModel.isEditing ? .constant(.active) : .constant(.inactive))
        .alert(isPresented: $viewModel.showDeleteAlert) {
            Alert(
                title: Text(LocalizedStrings.Alerts.deleteLandmarkTitle),
                message: Text(LocalizedStrings.Alerts.deleteLandmarkDescription),
                primaryButton: .destructive(Text(LocalizedStrings.Buttons.delete)) {
                    if let landmarkToDelete = viewModel.landmarkToDelete {
                        viewModel.deleteLandmark(landmarkToDelete)
                    }
                },
                secondaryButton: .cancel {
                    viewModel.setItemToDelete(nil)
                }
            )
        }
    }
    
    private func deleteLandmark(landmark: Landmark) {
        if let index = viewModel.landmarks.firstIndex(of: landmark) {
            withAnimation {
                let landmark = viewModel.landmarks[index]
                viewModel.deleteLandmark(landmark)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Landmark.self, configurations: config)

    for i in 1..<10 {
        let user = Landmark(id: UUID(), title: "title", details: "details")
        container.mainContext.insert(user)
    }

    return ContentView()
        .modelContainer(container)
}
