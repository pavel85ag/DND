

import Foundation
import UIKit


var photoURLs: [URL]!
var largePhotoURLs: [URL]!

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
