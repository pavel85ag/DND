

import Foundation
import FlickrKit


var tagValue : String = ""
var photoURLs: [URL]!
var largePhotoURLs: [URL]!
var numberOfImages = Int()
var completeAuthOp: FKDUNetworkOperation!
var checkAuthOp: FKDUNetworkOperation!
var userID: String?


func searchNewURLs (forText searchText: String, andSegueFromVC segueFromVC: UIViewController, bySegueIdent segueIdent : String) {
    

tagValue =  searchText 

photoURLs.removeAll()
largePhotoURLs.removeAll()
    
FlickrKit.shared().call("flickr.photos.search", args: ["tags": tagValue, "per_page": String(numberOfImages)] , maxCacheAge: FKDUMaxAge.neverCache, completion: { (response, error) -> Void in
    
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
            
            
            //  self.performSegue(withIdentifier: "SegueToPhotos", sender: self)
            segueFromVC.performSegue(withIdentifier: segueIdent, sender: segueFromVC)
            
        }
    })
    
})
}
