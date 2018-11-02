//
//  LandmarkDetailViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LandmarkDetailViewController: SharedImagePickerController {
    
    
    var landmark: Landmark!
    
    var dataController: DataController!
    
    var fetchedResultsController:NSFetchedResultsController<Landmark>!
    
    var onDelete: (() -> Void)?
    
    var saveObserverToken: Any?


    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = landmark.name
        textLabel.text = landmark.result
        if let data = landmark.photo {
            imageView.image = UIImage(data: data)
        }
        
        
        //  setupView()
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @IBAction func deleteLandmark(sender: Any) {
        presentDeleteNotebookAlert()
    }
    
    
    
    @IBAction func webSearchTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.text = titleLabel.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LandmarkDetailViewController {
    func presentDeleteNotebookAlert() {
        let alert = UIAlertController(title: "Delete Landmark", message: "Do you want to delete this landmark?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteHandler(alertAction: UIAlertAction) {
        onDelete?()
    }
    
    
}

extension LandmarkDetailViewController {
    func makeToolbarItems() -> [UIBarButtonItem] {
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteLandmark(sender:)))
        return [trash]
    }

    
    /// Configure the current toolbar
    func configureToolbarItems() {
        toolbarItems = makeToolbarItems()
        navigationController?.setToolbarHidden(false, animated: false)
}



}

extension LandmarkDetailViewController {
    
    func addSaveNotificationObserver() {
        removeSaveNotificationObserver()
        saveObserverToken = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: dataController?.viewContext, queue: nil, using: handleSaveNotification(notification:))
    }
    
    func removeSaveNotificationObserver() {
        if let token = saveObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func handleSaveNotification(notification:Notification) {
        DispatchQueue.main.async {
        }
    }

}
