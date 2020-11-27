//
//  LandmarkListViewController.swift
//  Landmark ID
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import CoreData


class LandmarkListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: IBOutlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var placeHolderImage: UIImageView!
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: Properties
    
    var landmarkListViewModel = LandmarkListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1.0)
        getLandmarks()
        setupView()
        setTexts()
     

    }
    
    func setTexts() {
        messageTitle.text = "No saved landmarks"
        messageTitle.font = .systemFont(ofSize: 24, weight: .regular)
        messageTitle.textColor = .lightGray
        
        messageText.text = "All your tagged landmarks will be automatically saved here"
        messageText.font = .systemFont(ofSize: 17, weight: .regular)
        messageText.textColor = .lightGray
    }
    
    // MARK: Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    /// Fetch request of data stored inside Core Data model
    
    fileprivate func getLandmarks() {
        landmarkListViewModel.fetchAllLandmarks()
    }

    
    /// Delete landmark entity at index path
    
    func deleteLandmark(at indexPath: IndexPath) {
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        landmarkListViewModel.removeLandmark(at: indexPath.row)
        getLandmarks()
        tableView.endUpdates()
        
        updateView()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return landmarkListViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        landmarkListViewModel.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkCell", for: indexPath) as! LandmarkCell
        let landmarkVM = landmarkListViewModel.landmarks[indexPath.row]
        
        // Configure cell
        cell.configureCell(for: landmarkVM)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteLandmark(at: indexPath)
        default: ()
            
        }
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if let vc = segue.destination as? LandmarkDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.vm = landmarkListViewModel.landmarks[indexPath.row]
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.deleteLandmark(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: Helper Functions
    
    private func updateView() {
        
        if landmarkListViewModel.landmarks.count == 0 {
            tableView.isHidden = true
            placeholderView.isHidden = false
            placeHolderImage.alpha = 0.2
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            tableView.isHidden = false
            placeholderView.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    private func setupView() {
        setupLabels()
        updateView()
    }
    
    private func setupLabels() {
        messageTitle.text = "No saved landmarks"
        messageText.text = "Your landmarks will be automatically saved here"
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
}
