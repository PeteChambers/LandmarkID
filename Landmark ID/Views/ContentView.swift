//
//  ContentView.swift
//  Landmark ID
//
//  Created by Pete Chambers on 27/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    //    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            ImageSourceView(viewModel: ImageSourceViewModel())
        }
    }
}

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }

