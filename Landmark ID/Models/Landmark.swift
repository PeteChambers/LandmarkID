//
//  Landmark.swift
//  Landmark ID
//
//  Created by Pete Chambers on 27/06/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Landmark {
    var id: UUID
    var title: String
    var details: String
    var image: Data?
    
    init(id: UUID = UUID(), title: String = "", details: String =  "", image: Data? = nil) {
        self.id = id
        self.title = title
        self.details = details
        self.image = image
    }
}
