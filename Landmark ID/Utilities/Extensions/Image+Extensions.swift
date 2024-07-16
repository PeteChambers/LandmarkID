//
//  Image+Extensions.swift
//  Landmark ID
//
//  Created by Pete Chambers on 16/07/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import SwiftUI

extension Image {
    func landmarkImageModifier() -> some View {
        self
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80, alignment: .center)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 3, x: 2, y: 2)
            .cornerRadius(8)
   }
}
