//
//  ContentView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 27/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ImageSourceView(viewModel: ImageSourceViewModel(dataSource: .shared))
        }
    }
}
