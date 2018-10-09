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

}


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

