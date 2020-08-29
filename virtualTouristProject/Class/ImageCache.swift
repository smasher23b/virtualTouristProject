//
//  ImageCache.swift
//  virtualTouristProject
//
//  Created by Ivan Arellano on 8/23/20.
//  Copyright © 2020 Ivan Arellano. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    //will get photos
    func getImageWithId(identifier: String?) -> UIImage? {
        
        if identifier == nil || identifier == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
//MARK: WILL STORE THE PHOTO
    func storeImage(image: UIImage?, withIdentifier identifier: String){
        
        let path = pathForIdentifier(identifier)
        
        if image == nil {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            }
            catch {
                
            }
            
            return
        }
        
        let data = UIImagePNGRepresentation(image!)
        data?.writetoFile(path, atomically: true)
    }
    
    //MARK: HELPER FUNCTION
    func pathForIdentifier(identifier: String) -> string {
        
        let documentsDirectoryURL : NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, indomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identier)
        return fullURL.path!
    }
    
}
