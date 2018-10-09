//
//  LandmarkDetail+CoreDataProperties.swift
//  
//
//  Created by Pete Chambers on 05/10/2018.
//
//

import Foundation
import CoreData


extension LandmarkDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LandmarkDetail> {
        return NSFetchRequest<LandmarkDetail>(entityName: "LandmarkDetail")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var name: String?
    @NSManaged public var landmark: Landmark?

}
