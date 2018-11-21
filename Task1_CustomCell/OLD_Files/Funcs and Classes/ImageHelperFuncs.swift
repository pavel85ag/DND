

import Foundation
import UIKit
import FlickrKit
import Photos
import CoreData
import MapKit


// MARK: - VARs

let defaults = UserDefaults.standard

var photoURLs: [URL]!
var largePhotoURLs: [URL]!
var photo_ids = [String]()

struct FavoritURL : Codable {
    var smallImageURL : URL
    var largeImageURL : URL
}

struct ImageWithGeolocation {
    var image : UIImage
    var coordinate : CLLocationCoordinate2D
    var coordIsAvailable : Bool
}
var currentImageWithGeo = ImageWithGeolocation(image: UIImage(named: "no_image")!, coordinate: CLLocationCoordinate2D(), coordIsAvailable: false)

var favoritURLs = [FavoritURL]()
var itemsToSave : [NSManagedObject] = []


// MARK: - Funcs

func calculateRowHeight (forImageInRow imageInRow: UIImage?) -> CGFloat {
    var imageWidth  = Int(240)
    var imageHeight = Int(120)
    
    if let cachedImage =  imageInRow {
        imageWidth  = Int(cachedImage.size.width)
        imageHeight = Int(cachedImage.size.height)
    }
    
    return (CGFloat((240*imageHeight/imageWidth) + 20))
}


func calculateItemWidth (forImageInItem imageInRow: UIImage?) -> CGFloat {
    var imageWidth  = Int(250)
    var imageHeight = Int(149)
    
    if let cachedImage =  imageInRow {
        imageWidth  = Int(cachedImage.size.width)
        imageHeight = Int(cachedImage.size.height)
    }
    
    return (CGFloat(149*imageWidth/imageHeight))
}




func searchNewURLs (forText searchText: String,  completion: @escaping ()-> Void) {
    LogAndSearchViewController.tagValue =  searchText
    photoURLs.removeAll()
    largePhotoURLs.removeAll()
    
    FlickrKit.shared().call("flickr.photos.search", args: ["tags": LogAndSearchViewController.tagValue, "per_page": String(LogAndSearchViewController.numberOfImages), "has_geo": "1"] , maxCacheAge: FKDUMaxAge.neverCache, completion: { (response, error) -> Void in
        DispatchQueue.main.async(execute: { () -> Void in
            if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                for photoDictionary in photoArray {
                    let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.small240, fromPhotoDictionary: photoDictionary)
                    let largePhotoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.large1024, fromPhotoDictionary: photoDictionary)
                    let photo_id = photoDictionary["id"] as! String
                    
                    photoURLs.append(photoURL)
                    largePhotoURLs.append(largePhotoURL)
                    photo_ids.append(photo_id)
                    
                    print(photoURL)
                    print(largePhotoURL)
                    print(photo_id)
                }
                
                completion()
            }
        })
    })
    
    
}

    
func loadImageForTable(url: URL, for indexPath: IndexPath, in tableView :UITableView) {

    DispatchQueue.global().async {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                SmallImagesTableViewController.cachedImages[url] = image
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) as? MyTableViewCell {
                        cell.optionalImage = image
                    }
                }
            }
        }
    }
}


func loadImageForFavoritsTable(url: URL, for indexPath: IndexPath, in tableView :UITableView) {
    
    DispatchQueue.global().async {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                FavouritesViewController.cachedImages[url] = image
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) as? FavoritsTableViewCell {
                        cell.optionalImage = image
                    }
                }
            }
        }
    }
}


func loadImageForCollection(url: URL, for indexPath: IndexPath, in collectionView :UICollectionView) {
    
    DispatchQueue.global().async {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                CollectionViewController.cachedImages[url] = image
                DispatchQueue.main.async {
                    
                    if let itemCell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                        itemCell.optionalImage = image
                    }
                }
            }
        }
    }
}


func fetchImage(to viewController: LargeImageViewController){
    if let url = viewController.imageURL {
        let urlContents = try? Data(contentsOf: url)
        if let imageData = urlContents {
            viewController.largeImageView.image = UIImage(data: imageData)
        }
    }
}


func updateDefaults() {
    defaults.set(try? PropertyListEncoder().encode(favoritURLs), forKey: "favoritsURL")
    print("defaults updated")
}


func loadDefaults() {
    if let data = UserDefaults.standard.value(forKey:"favoritsURL") as? Data {
        favoritURLs = ( try? PropertyListDecoder().decode(Array<FavoritURL>.self, from: data) ) ?? []
    }
    print(favoritURLs)
}


func saveImageWithGeo(imageWithGeo : UIImage, latitude : Double, longitude : Double, coordIsAvailable : Bool) {
    
    print("START SAVING")
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "ImgsWithGeo", in: managedContext)!
    let item = NSManagedObject(entity: entity, insertInto: managedContext)
    
    item.setValue(latitude, forKey: "latitude")
    item.setValue(longitude, forKey: "longitude")
    item.setValue(coordIsAvailable, forKey: "coordIsAvailable")
        if let data = UIImageJPEGRepresentation(imageWithGeo, 1) as NSData? {
            item.setValue(data, forKey: "image")
        }
    
    do {
        try managedContext.save()
        itemsToSave.append(item)
    } catch let error as NSError {
        print("failed to save item", error)
    }
}


func removeDuplicateInFavorits() {
    for i in 0..<favoritURLs.count - 1 {
        if favoritURLs[i].smallImageURL == favoritURLs[favoritURLs.count-1].smallImageURL{
            favoritURLs.remove(at: i)
            break
        }
    }
}


func updateCurrentImgWithGeo (image: UIImage, latitude: Double, longitude: Double, coordIsAvailable: Bool) {
    currentImageWithGeo.image = image
    currentImageWithGeo.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    currentImageWithGeo.coordIsAvailable = coordIsAvailable
}


func findGPSCoordinates(for url: URL) -> (latitude : Double, longitude : Double, coordIsAvailable : Bool) {
    
    var selfcoordIsAvailable = false
    var selfLatitude : Double
    var selfLongitude : Double
    selfLatitude  = 0.0
    selfLongitude = 0.0
    
    let string = url.absoluteString
    let nsurl = NSURL(string: string)
    let imageSource = CGImageSourceCreateWithURL(nsurl!, nil)
    let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil) as! NSDictionary
    print(imageProperties)
    
    for (key, _) in imageProperties {
        if (key as! String) == "{GPS}" {
            let gps = imageProperties["{GPS}"] as! NSDictionary
            let latitudeRef = gps["LatitudeRef"] as! String
            let longitudeRef = gps["LongitudeRef"] as! String
            selfLatitude = gps["Latitude"] as! Double
            selfLongitude = gps["Longitude"] as! Double
            selfcoordIsAvailable = true
            if latitudeRef == "S" {
                selfLatitude.negate()
            }
            if longitudeRef == "W" {
                selfLongitude.negate()
            }
        }
        
    }
    
    return (selfLatitude, selfLongitude, selfcoordIsAvailable)
    
}


func findFlickrGPSCoordinates(for photo_id: String, completion: @escaping ()-> Void) {
    
    let interesting = FKFlickrPhotosGeoGetLocation()
    interesting.photo_id = photo_id
    
    FlickrKit.shared().call(interesting) { response, error in
        if response != nil {
            let imageGPSProperties = response! as NSDictionary
            print("IMAGE PROPERTIES", imageGPSProperties)
            
            let photoDict = imageGPSProperties["photo"] as! NSDictionary
            let locationDict = photoDict["location"] as! NSDictionary
            
            let latitude = locationDict["latitude"] as! NSString
            let longitude = locationDict["longitude"] as! NSString
            
            DispatchQueue.main.async {
                currentImageWithGeo.coordinate.latitude = latitude.doubleValue
                currentImageWithGeo.coordinate.longitude = longitude.doubleValue
                currentImageWithGeo.coordIsAvailable = true
               
                completion()
                
            }
        } else {
            DispatchQueue.main.async {
                currentImageWithGeo.coordinate.latitude = 0.0
                currentImageWithGeo.coordinate.longitude = 0.0
                currentImageWithGeo.coordIsAvailable = false
                
                completion()
            }
        }
    }
}
