//
//  LandmarkCell.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 11/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit

internal final class LandmarkCell: UITableViewCell, Cell {
    // Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        
    }
    
}

