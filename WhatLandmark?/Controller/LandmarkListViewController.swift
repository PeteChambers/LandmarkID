//
//  LandmarkListViewController.swift
//  WhatLandmark?
//
//  Created by Pete Chambers on 28/09/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import UIKit
import CoreData

class LandmarkCell: UITableViewCell {
    @IBOutlet weak var landmarkName: UILabel!
    @IBOutlet weak var LandmarkPhoto: UIImageView!
}

class LandmarkListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userArray = NSMutableArray()
    
    var dataContoller: DataController!
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        requestUserData()
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
    
    func requestUserData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Landmark")
        request.returnsObjectsAsFaults = false
        do {
            let result = try dataContoller.viewContext.fetch(request)
            print("resultsdata=", result)
            for data in result as! [NSManagedObject] {
                userArray.add(data)
            }
            print("userArray!!=", self.userArray)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            
        }
        catch {
            print("failed")
            
        }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    
    // MARK: - Table view data source
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkCell", for: indexPath) as! LandmarkCell
        
        // Configure cell
        cell.landmarkName.text = (userArray[indexPath.row] as AnyObject).value(forKey: "name") as? String
        cell.LandmarkPhoto.image = (userArray[indexPath.row] as AnyObject).value(forKey: "photo") as? UIImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.userArray.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
}
    
    
    // MARK: - Navigation
    
  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
   //     if let vc = segue.destination as? LandmarkDetailViewController {
   //         if let indexPath = tableView.indexPathForSelectedRow {
    //            vc.landmark = fetchedResultsController.object(at: indexPath)
    //            vc.dataController = dataController
    //        }
     //   }
   // }
    
}

