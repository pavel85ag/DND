

import Foundation
import UIKit
import FlickrKit


let defaults = UserDefaults.standard

var photoURLs: [URL]!
var largePhotoURLs: [URL]!

struct favoritURL : Codable {
    var smallImageURL : URL
    var largeImageURL : URL
}
var favoritURLs = [favoritURL]()

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
    FlickrKit.shared().call("flickr.photos.search", args: ["tags": LogAndSearchViewController.tagValue, "per_page": String(LogAndSearchViewController.numberOfImages)] , maxCacheAge: FKDUMaxAge.neverCache, completion: { (response, error) -> Void in
        DispatchQueue.main.async(execute: { () -> Void in
            if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                for photoDictionary in photoArray {
                    let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.small240, fromPhotoDictionary: photoDictionary)
                    let largePhotoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.large1024, fromPhotoDictionary: photoDictionary)
                    photoURLs.append(photoURL)
                    largePhotoURLs.append(largePhotoURL)
                    print(photoURL)
                    print(largePhotoURL)
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
        favoritURLs = ( try? PropertyListDecoder().decode(Array<favoritURL>.self, from: data) ) ?? []
    }
    print(favoritURLs)
}

