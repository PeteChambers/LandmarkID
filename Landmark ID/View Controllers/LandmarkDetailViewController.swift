//
//  LandmarkDetailViewController.swift
//  Landmark ID
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import UIKit
import Network

class LandmarkDetailViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var webSearchButton: UIButton!
    
    
    // MARK: Properties
    
    var vm : ImageSourceViewModel?
    
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
        self.alertChoice(message: "Do you want to delete this landmark?", title: "Delete Landmark", buttonOneTitle: "Cancel", buttonTwoTitle: "Delete", handler: deleteHandler)
    }
    
    
    @IBAction func webSearchTapped(_ sender: Any) {
        if NetworkReachability.sharedInstance.isNetworkAvailable() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.text = self.titleLabel.text!
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.alert(message: "Please check your connection and try again.", title: "No internet connection", buttonTitle: "Ok")
        }
    }
    
    func deleteHandler(alertAction: UIAlertAction) {
        vm?.onDelete?()
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

