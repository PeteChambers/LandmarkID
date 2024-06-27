//
//  ImageSourceViewModel.swift
//  Landmark ID
//
//  Created by Peter Chambers on 18/11/2020.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import UIKit
import SwiftUI

protocol ImageSourceViewModelObservable: ObservableObject {
    var showHistory: Bool { get set }
}

class ImageSourceViewModel: ImageSourceViewModelObservable, Identifiable {
    
    @Published var showHistory: Bool = false
    
}
