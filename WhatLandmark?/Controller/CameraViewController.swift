//
//  CameraViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import CoreData

class CameraViewController: SharedImagePickerController {
    
    let session = URLSession.shared
  
    var landmark: Landmark!
    
    var dataController: DataController!
    
    
    
    /// The Core Data managed context
    var managedContext : NSManagedObjectContext?

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var landmarkResults: UITextView!
    @IBOutlet weak var CameraPhoto: UIImageView!
    
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let sharedImagePickerController = UIImagePickerController()
        sharedImagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo  Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            sharedImagePickerController.sourceType = .camera
            self.present(sharedImagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            sharedImagePickerController.sourceType = .photoLibrary
            self.present(sharedImagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil )
    }
    
 override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("imageTapped:")))
        CameraPhoto.addGestureRecognizer(tapGesture)
        CameraPhoto.isUserInteractionEnabled = true
        activityIndicator.hidesWhenStopped = true
        coreDataSetup()
        
    }
        
    
    
  //  override func viewDidAppear(_ animated: Bool) {
      //  if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
         //   let sharedImagePickerController = UIImagePickerController()
          //  sharedImagePickerController.delegate = self
          //  sharedImagePickerController.sourceType = UIImagePickerController.SourceType.camera
          //  sharedImagePickerController.allowsEditing = false
         //   self.present(sharedImagePickerController, animated: true, completion: nil)
       // }
   // }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            CameraPhoto.contentMode = .scaleAspectFit
            CameraPhoto.image = pickedImage
            activityIndicator.startAnimating()
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)

        
    
        dismiss(animated: true, completion: nil)
        prepareImageForSaving(pickedImage)
    
        }
    }
    
    func saveLandmark(givenName: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Landmark", in: dataController.viewContext)
        let item = NSManagedObject(entity: entity!, insertInto: dataController.backgroundContext!)
        item.setValue(givenName, forKey: "name")
        do {
            try dataController.backgroundContext!.save()
        } catch {
            print("Something went wrong")
        }
    }
    
    
}
    
        

    




