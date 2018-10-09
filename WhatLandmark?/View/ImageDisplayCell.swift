//
//  ImageDisplayCell.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 05/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit


class ImageDisplayCell : UITableViewCell {
    
    fileprivate static var storedDateFormatter : DateFormatter?
    static var dateFormatter : DateFormatter {
        if let storedDateFormatter = storedDateFormatter {
            return storedDateFormatter
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            storedDateFormatter = formatter
            return formatter
        }
    }
    
 
    @IBOutlet weak var thumbnailView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        thumbnailView.layer.cornerRadius = thumbnailView.frame.width / 2
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true
    }
    
}
