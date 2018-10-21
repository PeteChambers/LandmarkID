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
    
    var dataController: DataController!
    
    
    
    @IBOutlet weak var landmarkResults: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var CameraPhoto: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBAction func saveTapped(_ sender: Any) {
        addLandmarkPhoto(named: landmarkResults.text!, with: CameraPhoto.image!)
        do {
    
            try dataController.viewContext.save()
            saveConfirmation()
            
        }
        catch {
            print("failed to save data")
        }
    
        
    }
    
       
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
    
    
    @IBAction func recentsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandmarkListViewController") as! LandmarkListViewController
        vc.dataController = dataController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        landmarkResults.isEnabled = false
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            CameraPhoto.contentMode = .scaleAspectFit
            CameraPhoto.image = pickedImage
            activityIndicator.startAnimating()
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    func saveConfirmation() {
        
        let alert = UIAlertController(title: "Success", message: "Landmark saved to Recents.", preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    
        self.present(alert, animated: true)
        
    }
    
    
    
    
    func addLandmarkPhoto(named: String, with image: UIImage) {
        let landmarkPhotoEntity = NSEntityDescription.entity(forEntityName: "Landmark", in: dataController.viewContext)
        let newLandmarkPhoto = NSManagedObject(entity: landmarkPhotoEntity!, insertInto: dataController.viewContext)
        let data = NSData(data: image.jpegData(compressionQuality: 0.3)!)
        newLandmarkPhoto.setValue(data, forKey: "photo")
        let landmarkNameEntity = NSEntityDescription.entity(forEntityName: "Landmark", in: dataController.viewContext)
        let newLandmarkName = NSManagedObject(entity: landmarkNameEntity!, insertInto: dataController.viewContext)
        newLandmarkName.setValue(landmarkResults.text, forKey: "name")
        

}

}

