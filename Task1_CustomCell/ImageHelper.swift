//
//  ImageHelper.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 11/9/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import Foundation
import UIKit
import FlickrKit
import Photos
import CoreData
import MapKit


// MARK: - VARs

struct PhotoUrlAndProperties {
    var smallPhotoURL : URL?
    var largePhotoURL : URL?
    var photo_id      : String
    var givenName     : String
    var gpsAvailable  : Bool
    var latitude      : Double
    var longitude     : Double
    var isFavorit     : Bool
}

var favoritPhoto_idDict : Dictionary<String, Bool> = [:]
var searchedPhotos = [PhotoUrlAndProperties]()
var currentPhotoWithProp = PhotoUrlAndProperties(smallPhotoURL: URL(string: ""), largePhotoURL: URL(string: ""), photo_id: "", givenName: "", gpsAvailable: false, latitude: 0.0, longitude: 0.0, isFavorit: false)
var objectsToSave : [NSManagedObject] = []

let userDefaults = UserDefaults.standard

//MARK: Functions

func searchNewPhotos (forText searchText: String,  completion: @escaping ()-> Void) {
    
    searchedPhotos.removeAll()
    
    FlickrKit.shared().call("flickr.photos.search", args: ["tags": searchText, "per_page": "20", "has_geo": "1"] , maxCacheAge: FKDUMaxAge.neverCache, completion: { (response, error) -> Void in
        DispatchQueue.main.async(execute: { () -> Void in
            if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                for photoDictionary in photoArray {
                    let smallPhotoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.small240, fromPhotoDictionary: photoDictionary)
                    let largePhotoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.large1024, fromPhotoDictionary: photoDictionary)
                    let photo_id = photoDictionary["id"] as! String
                    
                    currentPhotoWithProp.givenName = ""
                    currentPhotoWithProp.smallPhotoURL = smallPhotoURL
                    currentPhotoWithProp.largePhotoURL = largePhotoURL
                    currentPhotoWithProp.photo_id = photo_id
                    
                    searchedPhotos.append(currentPhotoWithProp)
                    
                    findFlickrGPSCoordinates(for: photo_id, index: searchedPhotos.count-1, completion:{})
                }
                
                for i in searchedPhotos.indices {
                    
                    let photo_id = searchedPhotos[i].photo_id
                    searchedPhotos[i].isFavorit = favoritPhoto_idDict[photo_id] ?? false
                }
                
                completion()
            }
        })
    })
}


func findFlickrGPSCoordinates(for photo_id: String, index: Int, completion: @escaping ()-> Void) {
    
    
    let interesting = FKFlickrPhotosGeoGetLocation()
    interesting.photo_id = photo_id
    
    FlickrKit.shared().call(interesting) { response, error in
        
        if response != nil {
            let imageGPSProperties = response! as NSDictionary
            
            let photoDict = imageGPSProperties["photo"] as! NSDictionary
            let locationDict = photoDict["location"] as! NSDictionary
            
            let latitude = locationDict["latitude"] as! NSString
            let longitude = locationDict["longitude"] as! NSString
            
            DispatchQueue.main.async {
                if searchedPhotos.count != 0 {
                    searchedPhotos[index].gpsAvailable = true
                    searchedPhotos[index].latitude = latitude.doubleValue
                    searchedPhotos[index].longitude = longitude.doubleValue
                }
                completion()
                
            }
        } else {
            DispatchQueue.main.async {
                if searchedPhotos.count != 0 {
                    searchedPhotos[index].gpsAvailable = false
                    searchedPhotos[index].latitude = 0.0
                    searchedPhotos[index].longitude = 0.0
                }
                
                completion()
            }
        }
    }
}


func loadImageForSearchTable(url: URL, for indexPath: IndexPath, in tableView :UITableView) {
    
    DispatchQueue.global().async {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) as? ImagePropTableViewCell {
                        cell.optionalImage = image
                    }
                }
            }
        }
    }
}


func saveImageGeoProps () {
    
    let managedContext = persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "ImageFullGeoProps", in: managedContext)!
    let item = NSManagedObject(entity: entity, insertInto: managedContext)
    
    item.setValue(currentPhotoWithProp.smallPhotoURL?.absoluteString, forKey: "smallPhotoURL")
    item.setValue(currentPhotoWithProp.largePhotoURL?.absoluteString, forKey: "largePhotoURL")
    item.setValue(currentPhotoWithProp.givenName, forKey: "givenName")
    item.setValue(currentPhotoWithProp.photo_id, forKey: "photo_id")
    item.setValue(currentPhotoWithProp.latitude, forKey: "latitude")
    item.setValue(currentPhotoWithProp.longitude, forKey: "longitude")
    item.setValue(currentPhotoWithProp.isFavorit, forKey: "isFavorit")
    item.setValue(currentPhotoWithProp.gpsAvailable, forKey: "gpsAvailable")
    
    do {
        try managedContext.save()
        objectsToSave.append(item)
    } catch let error as NSError {
        print("failed to save item", error)
    }
}


func loadSavedToFavorits () {
    
    let managedContext = persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageFullGeoProps")
    do {
        objectsToSave = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("failed to fetch", error)
    }
    
    for i in objectsToSave.indices {
        let object = objectsToSave[i]
        
        let smallPhotoURL = URL(string: (object.value(forKeyPath: "smallPhotoURL") as! String))
        let largePhotoURL = URL(string: (object.value(forKeyPath: "largePhotoURL") as! String))
        let photo_id = object.value(forKeyPath: "photo_id") as! String
        let givenName = object.value(forKeyPath: "givenName") as! String
        let latitude = object.value(forKeyPath: "latitude") as! Double
        let longitude = object.value(forKeyPath: "longitude") as! Double
        let isFavorit = object.value(forKeyPath: "isFavorit") as! Bool
        let gpsAvailable = object.value(forKeyPath: "gpsAvailable") as! Bool
        
        FavoritsViewController.favoritsPhotos.append(PhotoUrlAndProperties(smallPhotoURL: smallPhotoURL, largePhotoURL: largePhotoURL, photo_id: photo_id, givenName: givenName, gpsAvailable: gpsAvailable, latitude: latitude, longitude: longitude, isFavorit: isFavorit))
        favoritPhoto_idDict[photo_id] = true
    }
    
}


func addToFavoritsAndSave (index : Int, name : String) {
    searchedPhotos[index].isFavorit = true
    searchedPhotos[index].givenName = name
    
    FavoritsViewController.favoritsPhotos.append(searchedPhotos[index])
    currentPhotoWithProp = searchedPhotos[index]
    favoritPhoto_idDict[searchedPhotos[index].photo_id] = true
   
    saveImageGeoProps()
}

        
func makePinFromStruct (_ item: PhotoUrlAndProperties) -> PinAnnotationImage {
    
    let title = item.photo_id
    let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
    let image = loadImageForUrl(item.smallPhotoURL!, scale: 4)
    let id = item.photo_id
    
    let pinAnnotationImage = PinAnnotationImage(title: title, coordinate: coordinate, image: image, id: id)
    
    return pinAnnotationImage
}


func loadImageForUrl(_ url : URL, scale: CGFloat) -> UIImage {
    var selfImage = UIImage()
    if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data, scale: scale){
            selfImage = image
        }
    }
    return selfImage
}


// MARK: - Core Data stack

 var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "SavedData")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()


// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

