//
//  LandmarkListViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import CoreData


class LandmarkListViewController: UIViewController, UITableViewDelegate {
    

    @IBOutlet var tableView: UITableView!
    
    var dataController: DataController!
    
    var tableViewDataSource = TableViewDataSource()

   // let allLandmarks = TempLandmark.allLandmarks
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages { (landmarks) -> Void in
            
            var newLandmarks : [Landmark] = []
            
            for landmark in landmarks {
                
                // filter out duplicates
                let isDuplicate = self.tableViewDataSource.data.contains {
                    return $0.id == landmark.id
                }
                
                if !isDuplicate {
                    newLandmarks.append(landmark)
                }
            }
            
            var paths : [IndexPath] = []
            let start = self.tableViewDataSource.data.count
            self.tableViewDataSource.data += newLandmarks.map { return (image:$0.image ?? UIImage(),id:$0.id ?? 0.0) }
            let end = self.tableViewDataSource.data.count
            
            for i in start..<end {
                paths.append(IndexPath(row: i, section: 0))
            }
            
            // make sure it updates happen on the main thread
            Run.main {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: paths, with: UITableView.RowAnimation.fade)
                self.tableView.endUpdates()
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // Actions
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.allLandmarks.count
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkCell")!
//        let landmark = self.allLandmarks[(indexPath as NSIndexPath).row]
        
        // Set the name and image
//        cell.textLabel?.text = landmark.name
//        cell.imageView?.image = UIImage(named: landmark.image)
        
        
//        return cell
//  }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier:
    //"LandmarkDetailViewController") as! LandmarkDetailViewController
//        detailController.tempLandmark = self.allLandmarks[(indexPath as NSIndexPath).row]
//        self.navigationController!.pushViewController(detailController, animated: true)
        
 //   }
//}


    // MARK: - Table view data source


//    func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController.sections?.count ?? 1
//    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let aLandmark = fetchedResultsController.object(at: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: LandmarkCell.defaultReuseIdentifier, for: indexPath) as! LandmarkCell
        
    

    // Configure cell
 //   cell.nameLabel.text = aLandmark.name

 //   if let count = aLandmark.landmarkDetail?.count {
 //       let pageString = count == 1 ? "page" : "pages"
 //       cell.pageCountLabel.text = "\(count) \(pageString)"
    

 //   return cell
}




    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       // if let vc = segue.destination as? LandmarkDetailViewController {
        //    if let indexPath = tableView.indexPathForSelectedRow {
           // vc.imageView = Landmark.image
                
//           }
//       }


extension LandmarkListViewController:NSFetchedResultsControllerDelegate {

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
    }

}

