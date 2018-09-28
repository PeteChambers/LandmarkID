//
//  LandmarkListViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import CoreData


class LandmarkListView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    // var dataController: DataController!
    
    let allLandmarks = TempLandmark.allLandmarks
    
    // var fetchedResultsController: NSFetchedResultsController<Landmark>!
    
    // fileprivate func setupFetchedResultsController() {
    // let fetchRequest:NSFetchRequest<Landmark> = Landmark.fetchRequest()
    
    // fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    // fetchedResultsController.delegate = self as! NSFetchedResultsControllerDelegate
    // do {
    // try fetchedResultsController.performFetch()
    // } catch {
    // fatalError("The fetch could not be performed: \(error.localizedDescription)")
    // }
    // }
    
    //override func viewDidLoad() {
    // super.viewDidLoad()
    
    // setupFetchedResultsController()
    //}
    
    // override func viewWillAppear(_ animated: Bool) {
    // super.viewWillAppear(animated)
    // setupFetchedResultsController()
    //if let indexPath = tableView.indexPathForSelectedRow {
    //tableView.deselectRow(at: indexPath, animated: false)
    //tableView.reloadRows(at: [indexPath], with: .fade)
    // }
    //}
    
    //override func viewDidDisappear(_ animated: Bool) {
    // super.viewDidDisappear(animated)
    // fetchedResultsController = nil
    // }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allLandmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkCell")!
        let landmark = self.allLandmarks[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = landmark.name
        cell.imageView?.image = UIImage(named: landmark.image)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "LandmarkDetailViewController") as! LandmarkDetailViewController
        detailController.tempLandmark = self.allLandmarks[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}





// func numberOfSections(in tableView: UITableView) -> Int {
//     return fetchedResultsController.sections?.count ?? 1
// }

// func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//     return fetchedResultsController.sections?[section].numberOfObjects ?? 0
// }

// func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//     let aLandmark = fetchedResultsController.object(at: indexPath)
//     let cell = tableView.dequeueReusableCell(withIdentifier: LandmarkCell.defaultReuseIdentifier, for: indexPath) as! LandmarkCell

// Configure cell
//  cell.nameLabel.text = aLandmark.name

//   if let count = aLandmark.landmarkDetail?.count {
//       let pageString = count == 1 ? "page" : "pages"
//       cell.pageCountLabel.text = "\(count) \(pageString)"
//   }

//    return cell
//  }



// -------------------------------------------------------------------------
// MARK: - Navigation

// override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
// If this is a NotesListViewController, we'll configure its `Notebook`
// if let vc = segue.destination as? LandmarkDetailViewController {
// if let indexPath = tableView.indexPathForSelectedRow {
// vc.landmark = fetchedResultsController.object(at: indexPath)
// vc.dataController = dataController
// }
// }
// }
//}

//extension LandmarkListViewController:NSFetchedResultsControllerDelegate {

//func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
// switch type {
// case .insert:
// tableView.insertRows(at: [newIndexPath!], with: .fade)
// break
// case .delete:
// tableView.deleteRows(at: [indexPath!], with: .fade)
// break
// case .update:
// tableView.reloadRows(at: [indexPath!], with: .fade)
// case .move:
// tableView.moveRow(at: indexPath!, to: newIndexPath!)
// }
// }

// func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
// let indexSet = IndexSet(integer: sectionIndex)
// switch type {
// case .insert: tableView.insertSections(indexSet, with: .fade)
// case .delete: tableView.deleteSections(indexSet, with: .fade)
// case .update, .move:
// fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
// }
// }


// func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
// tableView.beginUpdates()
// }

// func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
// tableView.endUpdates()
// }

// }

