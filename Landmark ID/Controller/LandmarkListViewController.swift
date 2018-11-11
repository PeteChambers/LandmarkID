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
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var placeHolderImage: UIImageView!
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: Properties
    
    var fetchedResultsController:NSFetchedResultsController<Landmark>!
    var userArray: [Landmark] = []
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1.0)
        requestUserData()
        setupView()
     

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
        
    fileprivate func requestUserData() {
        let fetchRequest:NSFetchRequest<Landmark> = Landmark.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    
    /// Delete landmark entity at index path
    
    func deleteLandmark(at indexPath: IndexPath) {
        let landmarkToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(landmarkToDelete)
        try? dataController.viewContext.save()
    }
    
    
   
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alandmark = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkCell", for: indexPath) as! LandmarkCell
        
        // Configure cell
        cell.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        cell.landmarkName.text = alandmark.name
        if let data = alandmark.photo {
        cell.landmarkImage.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteLandmark(at: indexPath)
        default: ()         }
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if let vc = segue.destination as? LandmarkDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.landmark = fetchedResultsController.object(at: indexPath)
                vc.dataController = dataController
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
        var hasLandmarks = false
        
        if let landmark = fetchedResultsController.fetchedObjects {
            hasLandmarks = landmark.count > 0
        }
        
        tableView.isHidden = !hasLandmarks
        messageTitle.isHidden = hasLandmarks
        messageText.isHidden = hasLandmarks
        placeHolderImage.isHidden = hasLandmarks
        placeHolderImage.alpha = 0.2
    }
    
    
    private func setupView() {
        setupLabels()
        updateView()
    }
    
    private func setupLabels() {
        messageTitle.text = "No saved landmarks"
        messageText.text = "Your landmarks will be automatically saved here"
    }
    
    func updateEditButtonState() {
        if let sections = fetchedResultsController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
}


        
extension LandmarkListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()

    }
    
}
