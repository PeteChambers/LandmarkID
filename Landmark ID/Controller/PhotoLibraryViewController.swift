//
//  PhotoLibraryViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import SwiftyJSON


class PhotoLibraryViewController: SharedImagePickerController {
    
    let session = URLSession.shared
    
    @IBOutlet weak var LibraryPhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        let sharedImagePickerController = UIImagePickerController()
        sharedImagePickerController.delegate = self
        sharedImagePickerController.allowsEditing = false
        sharedImagePickerController.sourceType = .photoLibrary
        
        present(sharedImagePickerController, animated: true, completion: nil)

    }
        
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            LibraryPhoto.contentMode = .scaleAspectFit
            LibraryPhoto.image = pickedImage
        }
        
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "SegueToResults", sender: self)
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToResults" {
            let destinationViewController = segue.destination as! ResultsViewController
            destinationViewController.TransferImage = LibraryPhoto.image
        }
    }
    
}


