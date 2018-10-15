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
    
    var fetchedResultsController:NSFetchedResultsController<Landmark>!
    

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var landmarkResults: UITextView!
    @IBOutlet weak var CameraPhoto: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBAction func saveTapped(_ sender: Any) {
        if landmarkResults.text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        presentNewLandmarkAlert()
        
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Landmark> = Landmark.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("imageTapped:")))
        CameraPhoto.addGestureRecognizer(tapGesture)
        CameraPhoto.isUserInteractionEnabled = true
        activityIndicator.hidesWhenStopped = true
        setupFetchedResultsController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
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
            }
        }
        saveAction.isEnabled = false
        
        // Add a text fieldDda
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
    
    func addLandmark(name: String) {
        let landmark = Landmark(context: dataController.viewContext)
        landmark.name = landmarkResults.text
        try? dataController.viewContext.save()
        print("landmark saved")
        
    }
        
    @IBAction func recentsPressed(_ sender: Any) {
        performSegue(withIdentifier: "SegueToRecents", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! LandmarkListViewController
                if let landmark = sender as? Landmark {
                    vc.landmark.name = landmarkResults.text
                    vc.dataController = dataController
                }
    }

}





