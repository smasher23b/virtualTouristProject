//
//  PhotoAlbumviewController.swift
//  virtualTouristProject
//
//  Created by Ivan Arellano on 8/26/20.
//  Copyright © 2020 Ivan Arellano. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class PhotoAlbumViewController : UIViewController, MKMapViewDelegate, UICollectionviewDataSource, UICollectionViewDelegate {
    
    //MARK: WILL DECLARE TOP LVL VAR
    
    var selectedPin : Pin!
    var photos : Photo!
    var page: Int = 1 //track what page we want to pull API
    var numOfPhotos: Int = 0
    var numbOnScreen: Int = 12 //SCREEN SPACE FOR 12: new collection after number is reach
    
    //MARK: outlets
    
    @IBOutlet weak var mapView: MKmapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollection: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noImagesFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///will zoom into map
        let span = MKCoordinateStateSPan(latitudeDelta: 1, longitude: 1)
        let coord = selectedPin!.coordinate
        
        let region = MKCoordinateRegion(center: coords, span: span)
        
        mapView.setRegion(region, animated: true)
        
        ///set up pin
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = MKCoordinateSpanself.mapView.addAnnotation(pinAnnotation)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let coords = selectedPin!.coordinate
        
        if selectedPin.Photos.count > 0 {
            print("we habe Images!")
        }
        else {
            print("No pictures found. Calling Flickr")
            
            let lat = coords.latitude
            let lng = coords.longitude
            
            //start activity indicator
            activityIndicator.startAnimating()
            getImagesFromFlickr(lat, lng: lng, page: self.page)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        saveContext()
    }
    
    //core data related funcs
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObject!
    }()
    func saveContext() {
        CoredataStackManager.sharedInstace().saveContext()
    }
    
    func deleteAllPics(){
        for photo in selectedPin.photos {
            sharedContext.deleteObject(photo)
            
            ///remove from docs directory
            let id: String = "\(photo.imageID).jpg"
            photo.removeFromDocumentsDirectory(id)
        }
    }
    
    //MARK: FLICKR FUNCTIONS
    func getImagesFromFlickr(lat: CLLocationDegrees, lng: CLLocationDegrees, page: Int) {
        
        FlickrClient.shsaredInstance().getImages(lat, lng, page: page){
            (json, error)in
            
            if error != "" {
                print("Error during newtwork activity \(error)")
            }
            if (!json.isEmpty) {
                //MARK: SAVE IMAGE
                
                for (_, subJson):(String, JSON) in json {
                    
                    let obj = subJson.object
                    let id = obj.valueForKey("id") {
                        
                        if let url = obj.valueForKey("url_l") {
                            
                            let dictionary : [String: AnyObject] = ["id" : id, "url" : url]
                            
                            ///parse through each & store to context
                            let photo = Photo(dictionary: dictionary, insertIntoManagedObjectContext: self.sharedContext)
                            
                            ///assing pin to photo
                            photo.pin = self.selectedPin
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.collectionView.reloadData()
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.hidden = true
                            }
                        }
                    }
                }
                else {
                    //MARK: NO PHOTOS DISPLAY INFO
                    dispatch_async(dispatch_get_main_queue()) {
                        self.noImagesFound.hidden = false
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                    }
    
                    
                    
func downloadFromFlickr(photo: Photo!, cell: PhotoCell!){
    ///tasks will be started; will download the image
    FlickrClient.sharedInstance().taskForImage(photo.url) { data, error in
        
        if let data = data {
            let image = UIImage(data: data)
            
            //MARK: CACHE
            photo.image = image
            
            ///update the main thread
            dispatch_async(dispatch_get_main_queue()) {
                cell.imageView!.image = image
                cell.loadingIndicator.stopAnimating()
                cell.loadingIndicator.hidden = true
            }
        }
    }
}
                    //MARK: COLLECTION VIEW FUNCTIONS
 func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                        return selectedPin.photos.count
                    }
                    
func collectionView(collectinView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let photo = selectedPin.photos[indexPath.item]
    var photoImage = UIImage(named: "placeholder)
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath) as! PhotoCell
    
    cell.loadingIndicator.hidden = false
    cell.loadingIndicator.startAnimating()
    cell.imageView.image = nil
    
    //MARK: SET THE PHOTO IMAGE
    if photo.image != nil {
        photoImage = photo.image
        cell.loadingIndicator.hideen = true
    }
    else {
        downloadFromFlickr(photo, cell: cell)
    }
    
    //MARK:CHECK LOCATION OF USER
    self.numOfPhotos += 1
    self.enabledCollectionbutton()
    
    cell.imageView.image = photoImage
    return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath)
        
                    let photo = selectedPin.photos[indexPath.item]
                    photo.pin = nil
                    
                    let imageIdentifier: String = "\(photo.imageID).jpg"
                    
                    //MARK:DELETE FROM CORE DATA
                    collectionView.deleteItemsAtIndexPaths([indexPath])
                    sharedContext.deleteObject(photo)
                    
                    photo.removeFromdocumentsDirectory(imageIdentifier)
                    
                    self.saveContext()
            }
                
                //MARK: ACTION BUTTONS
                func enabledCollectionButton() {
                    
                    if numOfPhotos == numbOnScreen {
                        newCollection.enabled = true
                    }
                }
                
                @IBAction func newCollectionStart(sender: AnyObject) {
                    
                    print("New Collection Requested")
                    deleteAllPics()
                    self.page++
                    getImagesFromFlickr(selectedPin.lat, lng: selectedPin.lng, page: page)
                }
        }
    
}
}
}
