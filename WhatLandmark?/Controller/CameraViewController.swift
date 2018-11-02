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
import SwiftSpinner

class CameraViewController: SharedImagePickerController {
    
    let session = URLSession.shared
    
    var dataController: DataController!
    
    var backgroundImage: UIImageView!
    
    @IBOutlet weak var landmarkResults: UITextField!
    @IBOutlet weak var wikiResults: UILabel!
    @IBOutlet weak var CameraPhoto: UIImageView!
    @IBOutlet weak var chooseImage: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    

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
        resetView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landmarkResults.isEnabled = false
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "londonBackground")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if backgroundImage.isHidden {
            chooseImage.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        } else {
            chooseImage.backgroundColor = UIColor.white
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            CameraPhoto.isHidden = true
            landmarkResults.isHidden = true
            wikiResults.isEnabled = true
            backgroundImage.isHidden = false
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            CameraPhoto.image = pickedImage
            SwiftSpinner.show("Analysing Image...")
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
            dismiss(animated: true, completion: nil)
            backgroundImage.isHidden = true
            titleLabel.isHidden = true
            textLabel.isHidden = true
            
        }

    }
    
    func saveToHistory() {
        addLandmarkEntity(name: landmarkResults.text!, result: wikiResults.text!, with: CameraPhoto.image!)
        do {
            
            try dataController.viewContext.save()
            saveConfirmation()
            
        }
        catch {
            print("failed to save data")
        }
        
    }
    
    func resetView() {
        backgroundImage.isHidden = false
        titleLabel.isHidden = false
        textLabel.isHidden = false
        CameraPhoto.isHidden = true
        landmarkResults.isHidden = true
        wikiResults.isHidden = true
        
    }
   
    
    
    func saveConfirmation() {
        
        let alert = UIAlertController(title: "Success", message: "Landmark saved to History", preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    
        self.present(alert, animated: true)
        
    }
    
    func noLandmarksFound() {
        
        let alert = UIAlertController(title: "No Landmarks Found!", message: "please use a different image and try again", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
        
    }
    
    

    
    func addLandmarkEntity(name: String, result: String, with image: UIImage) {
        let landmarkEntity = NSEntityDescription.insertNewObject(forEntityName: "Landmark", into: dataController.viewContext) as! Landmark
        landmarkEntity.setValue(landmarkResults.text, forKey: "name")
        landmarkEntity.setValue(wikiResults.text, forKey: "result")
        let data = NSData(data: image.jpegData(compressionQuality: 0.3)!)
        landmarkEntity.setValue(data, forKey: "photo")

}

}
