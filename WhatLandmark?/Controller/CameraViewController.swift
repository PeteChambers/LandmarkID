//
//  CameraViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftyJSON

class CameraViewController: SharedImagePickerController {
    
    let session = URLSession.shared
    
    @IBOutlet weak var CameraPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let sharedImagePickerController = UIImagePickerController()
            sharedImagePickerController.delegate = self
            sharedImagePickerController.sourceType = UIImagePickerController.SourceType.camera
            sharedImagePickerController.allowsEditing = false
            self.present(sharedImagePickerController, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            CameraPhoto.contentMode = .scaleAspectFit
            CameraPhoto.image = pickedImage
        }
        
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "SegueToResults", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToResults" {
            let destinationViewController = segue.destination as! ResultsViewController
            destinationViewController.TransferImage = CameraPhoto.image
        }
        
    }
    
}



