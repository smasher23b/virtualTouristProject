//
//  Coord.swift
//  virtualTouristProject
//
//  Created by Ivan Arellano on 8/23/20.
//  Copyright © 2020 Ivan Arellano. All rights reserved.
//

import Foundation
import MapKit
import CoreData

@objc(coords)

class Photo : NSManagedObject {
    
    @NSManaged var url: String
    @NSManaged var imageID: String
    @NSManage var pin: Pin?
    
    override init(entity: NSEntityDescription, insertIntomanageObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convinience init(dictionary: [String : AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext)  {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        url = dictionary["url"] as! String
        imageID = dictionary["id"] as! String
    }
    
    var image: UIImage? {
        
        get {
            return FlickerClient.Chache.image.getImageWithId("\(imageID).jpg")
        }
        
        set {
            FlickerClient.Cache.imageCache.storeImage(newValue, withIdentifier: "\(imageID).jpg)
        }
    }
    
    func removeFromDocumentsDirectory(identifier: String) {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory, inDomains: .userDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        let path = fullURL.path!
        
        do {
            try NSFileManager.defaultManager().removeAtPath(path)
        }
        catch _ {
            
        }
    }
}
