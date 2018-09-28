//
//  ResultsViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultsViewController: SharedImagePickerController {
    
    var landmarkText = String()
    var TransferImage: UIImage!
    let session = URLSession.shared
    
    @IBOutlet weak var landmarkResults: UITextView!
    
    @IBOutlet weak var image_from_library: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedImagePickerController.delegate = self
        image_from_library.image = TransferImage
        activityIndicator.hidesWhenStopped = true
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image_from_library.contentMode = .scaleAspectFit
            image_from_library.image = pickedImage
            activityIndicator.startAnimating()
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

