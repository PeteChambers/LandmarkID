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
    
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    @State private var itemToDelete: Landmark?
    
    var body: some View {
        Group {
            if viewModel.landmarks.isEmpty {
                ContentUnavailableView(
                    "No saved landmarks",
                    systemImage: "photo",
                    description: Text("All your tagged landmarks will be automatically saved here"))
            } else {
                List {
                    ForEach(viewModel.landmarks) { landmark in
                        HStack {
                            if isEditing {
                                Button(action: {
                                    itemToDelete = landmark
                                    showDeleteAlert = true
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
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            withAnimation {
                isEditing.toggle()
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
        .disabled(viewModel.landmarks.isEmpty))
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Landmark"),
                message: Text("Do you want to delete this landmark?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let landmarkToDelete = itemToDelete {
                        deleteLandmark(landmark: landmarkToDelete)
                    }
                },
                secondaryButton: .cancel()
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
