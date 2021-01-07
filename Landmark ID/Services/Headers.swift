//
//  Constants.swift
//  Landmark ID
//
//  Created by Peter Chambers on 07/01/2021.
//  Copyright © 2021 Pete Chambers. All rights reserved.
//

import Foundation

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case bundleIdentifier = "X-Ios-Bundle-Identifier"
}

enum ContentType: String {
    case json = "application/json"
    case charSet = "charset=UTF-8"
}

var standardHeaders: [String : String] {
    return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue, HTTPHeaderField.bundleIdentifier.rawValue: Bundle.main.bundleIdentifier ?? ""]
}
