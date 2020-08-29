//
//  MapViewController.swift
//  virtualTouristProject
//
//  Created by Ivan Arellano on 8/24/20.
//  Copyright © 2020 Ivan Arellano. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: INIT VARS OUTLETS & ETC
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var deletePinsLabel: UILabel!
    @IBOutlet weak var editNavButton: UIBarButtonItem!
    var mapChangedFromUserInt: false
    var sharedContext = coreDataStackManager.sharedInstance().managedObjectContect!
    
    //MARK: NAVIGATION BUTTON CLICK ACTION
    
    @IBOutlet func editNavButtonAction(sender: AnyObject) {
        
        if deletePinsLabel.hidde {
            
            ///state before was edited
            editNavButton.title = "Done"
            deletePinsLabel.hidden = false
        }
        else {
            
            /// before state is over will hide label
            editNavButton.title = "Edit"
            deletePinsLabel.hidden = true
        }
    }
    
    //MARK: ADD PIN
    @IBAction func addPin(sender: UIGestureRecognizer) {
        
        ///only add pins if its in the right mode
        if deletePinsLabel.hidden && UIGestureRecognizerState.Began == sender.state {
            
            ///grab coords
            let location = sender.locationInView(self.mapView)
            let locCoords = self.mapView.convertPoint(location, toCoordinateFromView: self.mapView)
            
            //save to context
            let lat : Double = locCoords.latitude
            let lng : Double = locCoords.longitude
            
            let pin = Pin(lat: lat, lng: lng, context: sharedContext)
            
            //print pin
            self.mapView.addAnnotation(pin)
            CoreDataStackManager.sharedInstance().saveContext()
        }
        else { detected but in wrong mode"
            
            print("Long press detetected but in wrong mode")
        }
    }
            
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        
        super.viewDidload()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "addPin")
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
        
        mapView.delegate = self
        
        fetchCoords()
        
        for entry in fetchedCoordsController.fetchedObjects as! [Coords] {
            /// print("Coords from orginal \(coord)")
            let coord = entry.lastLocation
            
            ///init location
            centerMapOnLocation(coord)
        }
        
        //MARK: ADD DATA TO OUR MAP
        mapView.addAnnotations(fetchPins())
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Handle title change on back clicks
        navigationItem.title = "Virtual Tourist"
    }
    
    ///will prepare seque way info
    override func prepareForSeque(seque: UIStoryboardSeque, sender: AnyObject?) {
        
        navigationItem.title = "OK"
        
        ///Pass variables to new vc
        let destinationVC = seque.destinationViewController as! PhotosViewController
        destinationVC.selectedPin = sender as! pin
    }
    
    //MARK:convience functions for core data; will get center records
    lazy var fetchedCoordsController: NSFetchedResultsController = {
        
        let var fetchedRequest = NSFetchRequest(enityName: "Coordinates")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastLocation", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()

    //MARK: WILL CHEKC FOR USER INTERACTION; MAP CHANGES
    func mapViewRegionDidChamgeFromUserInteration() -> Bool {
        
        let view = self.mapView.subViews[0]
        
        if let gestureRecognizers = view.gestureRecognizers {
            
            for recognizer in gestureRecognizers {
                
                if(recognizer.state == UIGestureRecognizerState.Began || recognizer.state == UIGestureRecorgnizerState.Ended){
                    
                    return true
                }
            }
        }
        return false
    }
    
    //MARK: FETCH ALL OUR PINS
    func fetchPins() -> [pin]{
        var error; NSError?
        
        let fetchRequest = NSFetchRequest(entityName: "pin")
        var results = []
        
        do {
            results = try sharedContext.executeFetchRequest(fetchRequest)
        }
        catch let error1 as NSError {
            error = error1
        }
        
        if let error = error {
            print("Error performing initial fetch: \(error)")
        }
        return results as! [Pin]
    }
    return results as! [Pin]
}
 //MARK: FETCH COORDINATES TO CENTER THE MAP ON VIEW
func fetchCoords(){
    
    var error: NSError?
     
    do {
        try fetchedCoordsController.performFetch()
    }
    catch let error1 as NSError {
        
        error = error1
    }
    
    if let error = error {
        print("Error performing initail fetch: \(error)")
    }
}

//MARK: DELETE COORDS
func deleteCoords(){
    
    print("deleting coords")
    
    fetchcoords()
    
    for coord in fetchedCoordsController.fetchedObjects as! [Coords] {
        sharedContect.deleteObject(coord)
    }
}

//MARK: DELEGATE FUNCTION FOR MAPS WILL RESPONSE TO TAPS

func mapView(mapview: MKMapView, didSelectAnnotationView: MKAnnotationView) {
    
    //MARK: ANNOTATION SELECTED WILL WANT TO SEQUE TO OUR OTHER VIEW OR DELETE
    let pin = view.annotaion as! pin
    if editNavBtn.title == "Edit" {
        
        performSequeWithIdentifier("toPhotoVC", sender: pin)
    }
    else {
        sharedContext.deleteObject(pin)
        mapView.removeAnnotation(view.annotation!)
        coreDataStackManager.sharedInstance().saveContext()
    }
}

func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    
    if9mapViewRegionDidChangedFromUserInteraction())) {
        
        let lat = mapView.centerCoordinate.Latitude.description
        let lng = mapView.centerCoordinate.longitude.descriptiion
        
        deleteCoords()
        
        let coords = Coords(insertIntoManagedObjectContext: sharedcontext)
        
        coords.lastLocation = CLLocation(latitude: mapView.centerCoordinate.latitude , longitude: mapView.centerCoordinate.longitude)
        
        CoreDataStackManager.sharedInstance().saveContext()
        
        print("region changed to \(lat) \(lng)")
    }
}

//MARK: HELPER FUNCTION TO CENTER BASED ON COORDS
func centerMapOnLocation(location: CLLocation) {
    
    mapView.setCenterCoodinate(location.coordinate, animated: true)
    
}


