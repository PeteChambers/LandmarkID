//
//  Landmark+CoreDataProperties.swift
//  
//
//  Created by Pete Chambers on 05/10/2018.
//
//

import Foundation
import CoreData


extension Landmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Landmark> {
        return NSFetchRequest<Landmark>(entityName: "Landmark")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var imageData: NSData?
    @NSManaged public var name: String?
    @NSManaged public var landmarkDetail: LandmarkDetail?

}
