//
//  FlickerClient.swift
//  virtualTouristProject
//
//  Created by Ivan Arellano on 8/23/20.
//  Copyright © 2020 Ivan Arellano. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FlickerClient: NSObject {
    
    //MARK: EXAMPLE URL
https://www.flickr.com/services/api/
    
    
    let FLICKR_API_KEY: String = ""
    let FLICKR_URL : String = ""
    let SEARCH_METHOD: String = ""
    let EXTRAS: String = ""
    let FORMAT_TYPE: String = "json"
    let JSON_CALLBACK: Int = 1
    let PER_PAGE: Int = 21
    
    override init() {
        super.init()
    }
    
    func getImages(lat: Double, lng: Double, page: Int, completionHandler: result: JSON!    , error: String?) -> Void) {
    
    Almofire.request(.GET, FLICKER_URL, parameters: ["method": SEARCH_METHOOD, "api_key": FLICKER_API_KEY, "lat": lat, "lon": lng, "extras": EXTRAS, "format": FORMAT_TYPE, "per_page": PER_PAGE, "page": page .responseJSON { response in
    
    let dataFromNetworking = response.data
    
    if(dataFromNewtworking != nil) {
    
    let json = JSON(data: dataFromNetworking!)
    
    if let imageUrls: JSON = json["photos"]["photo"] {
    
    completionHandler(result: imageUrls, error: "")
    return
            }
        }
    }
}
    func taskforImage(filePath: String, completionHandler: (imageData: NSData?, error: NSError?) -> Void {
    
    Alamofire.request(.GET, filePath).response { (request, response, data, error) in
    
    if let error = error {
    completionHandler(imageData: nil, error: error)
    }
    else {
    completionHandler(imageData: data, error: nil)
    
    }
    
    }
    }
    
    
    //MARK: SINGLETON
    class func sharedInstance() -> FlickerClient {
    
    struct Singleton {
        static let sharedInstance = FlickerClient()
    }
    
    return Singleton.sharedInstance
    }
    
    //MARK: IMAGE CHACHE
    struct cahce {
        static let imageChache = ImageCache()
    }
    }
