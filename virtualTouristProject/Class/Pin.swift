//
//  Pin.swift
//  virtualTouristProject
//
//  Created by Ivan Arellano on 8/23/20.
//  Copyright © 2020 Ivan Arellano. All rights reserved.
//

import Foundation
import MapKit
import CoreData

@objc(Photo)

class Photo: NSManagedObject {
    
    @NSManagedObject var url: String
    @NSManagedObject var imageID: String
    @NSManagedObject var pin: Pin?
    
    override init(entity: NSEntityDescription, insertIntoManageObjectContext contect: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManageObjectContext: insertIntoManageObjectContext)
    }
    
    conevenience init(dictionary: [String : AnyObject], insertIntoManageObjectContext context:NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        
        url dictionary["url"] as! String
        imageID = dictionary["id" as! String]
    }
    
    var image: UIImage? {
        
        get {
            return FlickerClient.Chace.imageCache.getImageWithId("\(imageID).jpg")
        }
        
        set {
            FlickerClient.Chace.imageCache.storeImage(newValue, withIdentifier: "\(imageID).jpg")
        }
    }
    
    func removeFromDocumentsDirectory(Identifier: String) {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultMAnager().URLsForDirectory(.DocumentDirectory, inDomains:
            .UserDomainMask).first!
        
        do {
            try! NSFileManager.defaultManager().removeItemAtPath(path)
        }
        catch {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        }
        catch _ {
        }
    }
}
