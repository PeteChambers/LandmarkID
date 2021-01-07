//
//  DataResponse.swift
//  Landmark ID
//
//  Created by Peter Chambers on 06/01/2021.
//  Copyright © 2021 Pete Chambers. All rights reserved.
//

import Foundation

struct DataResponse: Codable {
    let responses: [Response]
}

// MARK: - Response
struct Response: Codable {
    let landmarkAnnotations: [LandmarkAnnotation]
}

// MARK: - LandmarkAnnotation
struct LandmarkAnnotation: Codable {
    let landmarkAnnotationDescription: String

    enum CodingKeys: String, CodingKey {
        case landmarkAnnotationDescription = "description"
    }
}
