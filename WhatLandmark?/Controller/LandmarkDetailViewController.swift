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

class LandmarkDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var tempLandmark: TempLandmark!
    
    // var dataController:DataController!
    
    // var fetchedResultsController:NSFetchedResultsController<LandmarkDetail>!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    //fileprivate func setupFetchedResultsController() {
    //    let fetchRequest:NSFetchRequest<LandmarkDetail> = LandmarkDetail.fetchRequest()
    //    let predicate = NSPredicate(format: "landmark == %@", landmark)
    //    fetchRequest.predicate = predicate
    
    
    // fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    // fetchedResultsController.delegate = self as! NSFetchedResultsControllerDelegate
    
    // do {
    // try fetchedResultsController.performFetch()
    // } catch {
    // fatalError("The fetch could not be performed: \(error.localizedDescription)")
    // }
    // }
    
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.label.text = self.tempLandmark.name
        self.imageView!.image = UIImage(named: tempLandmark.image)
    }
    
    // override func viewWillDisappear(_ animated: Bool) {
    // super.viewWillDisappear(animated)
    // self.tabBarController?.tabBar.isHidden = false
    //}
    
    // override func viewDidDisappear(_ animated: Bool) {
    // super.viewDidDisappear(animated)
    // fetchedResultsController = nil
    // }
    
    //}
    
    //extension LandmarkDetailViewController: UITextViewDelegate {
    // func textViewDidEndEditing(_ textView: UITextView) {
    // try? dataController.viewContext.save()
    // }
    
}






