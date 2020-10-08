//
//  ImageSourceViewController.swift
//  Landmark ID
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreData
import SwiftSpinner

class ImageSourceViewController: SharedImagePickerController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var landmarkResults: UITextField!
    @IBOutlet weak var wikiResults: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var webSearchButton: UIButton!
    
    
    // MARK: Properties
    
    let session = URLSession.shared
    var dataController: DataController!
    var backgroundImage: UIImageView!
    override open var shouldAutorotate: Bool {
        return false
    }
    

    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landmarkResults.isEnabled = false
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "StPauls")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.backgroundColor = UIColor.black.withAlphaComponent(1)
        self.view.insertSubview(backgroundImage, at: 0)
        webSearchButton.isHidden = true
        setTexts()
    }
    
    func setTexts() {
        titleLabel.text = "Landmark ID"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 20)
        titleLabel.textColor = .white
        
        textLabel.text = "Start analysing your images and let Landmark ID's photo recognition software descover the landmarks within them"
        textLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)
        textLabel.textColor = .white
        
        landmarkResults.font = .preferredFont(forTextStyle: .title1)
        landmarkResults.textColor = .darkGray
        
        wikiResults.font = .systemFont(ofSize: 17, weight: .regular)
        wikiResults.textColor = .darkGray
        
        webSearchButton.setTitle("More...", for: .normal)
        webSearchButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        webSearchButton.setTitleColor(.systemBlue, for: .normal)
        
        chooseImageButton.setTitle("Choose an Image", for: .normal)
        chooseImageButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        chooseImageButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetView()
    }
    
    // MARK: Actioms

    @IBAction func chooseImage(_ sender: Any) {

        let sharedImagePickerController = UIImagePickerController()
        sharedImagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
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
    
   
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LandmarkListViewController") as! LandmarkListViewController
        vc.dataController = dataController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func webSearchTapped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.text = landmarkResults.text!
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "No internet connection", message: "Please check your connection and try again.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }

    
    /// Image Picker Controller Function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage.image = pickedImage
            SwiftSpinner.show("Analysing Image...")
            SwiftSpinner.shared.outerColor = UIColor.white;  SwiftSpinner.setTitleColor(UIColor.white)
            if Reachability.isConnectedToNetwork() {
                print("Internet connection available")
            }
            else {
                delay(seconds: 10.0, completion: {
                    SwiftSpinner.shared.outerColor = UIColor.red.withAlphaComponent(0.5)
                    SwiftSpinner.setTitleColor(UIColor.red)
                    SwiftSpinner.show("Failed to connect, please try again...", animated: false)
                })
                delay(seconds: 12.0, completion: {
                    SwiftSpinner.hide()
                    self.resetView()
                })
            }
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
            dismiss(animated: true, completion: nil)
            updateview()
        }

    }
    
    
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    /// Save Core Data Model to view contect function
    
    func saveToHistory() {
        addLandmarkEntity(name: landmarkResults.text!, result: wikiResults.text!, with: userImage.image!)
        do {
            
            try dataController.viewContext.save()
            saveConfirmation()
            
        }
        catch {
            print("failed to save data")
        }
        
    }
    
    /// Resets view to origiginal state
    
    func resetView() {
        [backgroundImage, titleLabel, textLabel].forEach({ $0.isHidden = false})
        [userImage, landmarkResults, wikiResults, webSearchButton].forEach({ $0.isHidden = true })
        chooseImageButton.backgroundColor = UIColor.white
        chooseImageButton.setTitleColor(.systemBlue, for: .normal)
        chooseImageButton.setTitle("Choose an Image", for: .normal)
    }
    
    
    /// Reinstates image and text properties
    
    func updateview() {
        [userImage, landmarkResults, wikiResults, webSearchButton].forEach({ $0.isHidden = false})
        [backgroundImage, titleLabel, textLabel].forEach({ $0.isHidden = true })
        chooseImageButton.backgroundColor = UIColor.systemBlue
        chooseImageButton.setTitleColor(.white, for: .normal)
        chooseImageButton.setTitle("Choose another Image", for: .normal)
    }
    
    /// Modal alert confirming that landmark's have been saved
    
    func saveConfirmation() {
        
        let alert = UIAlertController(title: "Success!", message: "Landmark saved to History", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2.5
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }

    }
    /// Modal alert warning user that no landmark has been found in user photo
    
    func noLandmarksFound() {
        
        let alert = UIAlertController(title: "No Landmarks Found!", message: "Please use a different image and try again", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        resetView()
    }
    
    
    /// Creates new Landmark entity, adds it into the view context and sets values for each attribute
    
    func addLandmarkEntity(name: String, result: String, with image: UIImage) {
        let landmarkEntity = NSEntityDescription.insertNewObject(forEntityName: "Landmark", into: dataController.viewContext) as! Landmark
        landmarkEntity.setValue(landmarkResults.text, forKey: "name")
        landmarkEntity.setValue(wikiResults.text, forKey: "result")
        let data = NSData(data: image.jpegData(compressionQuality: 0.3)!)
        landmarkEntity.setValue(data, forKey: "photo")

        }

    
    }


// MARK: Helper Functions

/// Disable autorotation of viewcontroller embedded inside navigationcontroller

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }}
