//
//  ChooseImageButton.swift
//  Landmark ID
//
//  Created by Pete Chambers on 22/07/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI

struct SelectImageButton: View {
    @State private var showOptions = false
    @State private var showCamera = false
    @State private var showPhotosPicker = false
    @Binding var showResults: Bool

    var body: some View {
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
}
