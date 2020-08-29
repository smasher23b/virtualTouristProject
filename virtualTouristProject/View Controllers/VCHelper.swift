//
//  VCHelper.swift
//  virtualTouristProject
//
//  Created by Ivan Arellano on 8/24/20.
//  Copyright © 2020 Ivan Arellano. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertError(errorString: String?){
        
        let aletController = UIAlertController(title: "Error Detected", message: errorString, preferresStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertactionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: urlString) {
        
        let url : USURL = NSURL(stringL urlString)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            self.image = UIImage(data: data!)
        });
}
}

