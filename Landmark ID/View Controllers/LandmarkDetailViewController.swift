//
//  LandmarkDetailViewController.swift
//  Landmark ID
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LandmarkDetailViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var webSearchButton: UIButton!
    
    
    // MARK: Properties
    
    var vm : ImageSourceViewModel?
    var onDelete: (() -> Void)?
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTexts()
        imageView.image = vm?.image
    }
    
    func setTexts() {
        titleLabel.text = vm?.name
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .darkGray
        
        textLabel.text = vm?.description
        textLabel.font = .systemFont(ofSize: 17, weight: .regular)
        textLabel.textColor = .darkGray
        
        webSearchButton.setTitle("More...", for: .normal)
        webSearchButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        webSearchButton.setTitleColor(.systemBlue, for: .normal)
    }
    

     // MARK: Actions
  
    @IBAction func deleteLandmark(sender: Any) {
        presentDeleteNotebookAlert()
    }
    
    
    @IBAction func webSearchTapped(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.text = titleLabel.text!
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "No internet connection", message: "Please check your connection and try again.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
}

/// Modal alert for deleting a landmark entity

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

// MARK: Helper Functions

extension LandmarkDetailViewController {
    func makeToolbarItems() -> [UIBarButtonItem] {
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteLandmark(sender:)))
        return [trash]
    }


    func configureToolbarItems() {
        toolbarItems = makeToolbarItems()
        navigationController?.setToolbarHidden(false, animated: false)
}


}

