//
//  LandmarkCell.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 19/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit

internal final class LandmarkCell: UITableViewCell {
    // Outlets

    @IBOutlet weak var landmarkName: UILabel!
    @IBOutlet weak var landmarkImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        landmarkName.text = nil
        landmarkImage.image = nil
    }
    
}
