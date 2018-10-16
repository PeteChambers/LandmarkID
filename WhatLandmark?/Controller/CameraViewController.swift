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
    
    @IBOutlet weak var landmarkResults: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var CameraPhoto: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBAction func saveTapped(_ sender: Any) {
        if landmarkResults.text == "" {
         
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }

        presentNewLandmarkAlert()
        
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
    
    func presentNewLandmarkAlert() {
        let alert = UIAlertController(title: "New Landmark", message: nil, preferredStyle: .alert)
        
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addLandmark(name: name)
                self?.saveConfirmation()
                
            }
        }
        saveAction.isEnabled = false
        
      
        alert.addTextField { textField in
            textField.text = self.landmarkResults.text
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
                
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveConfirmation() {
        
        let alert = UIAlertController(title: "Success", message: "Landmark saved to Recents.", preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    
        self.present(alert, animated: true)
        
    }
    
    func addLandmark(name: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Landmark", in: context!)
        let newLandmark = NSManagedObject(entity: entity!, insertInto: context!)
        newLandmark.setValue(landmarkResults.text, forKey: "name")
        do {
            try context?.save()
            print("save successful")
            
        }
        catch {
            print("failed to save data")
        }
    }
    
}





