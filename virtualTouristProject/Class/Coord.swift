//
//  PhotoCell.swift
//  virtualTouristProject
//
//  Created by Ivan Arellano on 8/23/20.
//  Copyright © 2020 Ivan Arellano. All rights reserved.
//

import Foundation
import MapKit
import CoreData

@obc Coords : NSManagedObject {
    
    @NSManaged var lastLocation: CLLocation
    
    override init(entity: NSEntityDescription, insertManaegdObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    override init(insertIntoMAnagedObjectContext context: NSManagedObjectContext) {
        let enity =  NSEntityDescription.entityForName("Coordinates", inManagedObjectContext: context)!
        self.init(enity: entity, insertIntoManagedObjectContext: context)
        
    }
}


