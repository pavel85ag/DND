import UIKit
import FlickrKit


class SmallImagesTableViewController: UITableViewController, MyTableViewCellButtonDelegate  {
    
    private var tappedCellTag = Int()
    static var cachedImages = [URL : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "Ident")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoURLs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ident", for: indexPath) as! MyTableViewCell
        cell.MyCellLable.text = "Click to get URL"
        cell.tag = indexPath.row
        cell.delegateCellButtonTap = self
        
        let url = photoURLs[indexPath.row]
        var image: UIImage? = nil
        if let cachedImage = SmallImagesTableViewController.cachedImages[url] {
            image = cachedImage
            cell.optionalImage = image
        } else {
            loadImageForTable(url: url, for: indexPath, in: tableView)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateRowHeight(forImageInRow: SmallImagesTableViewController.cachedImages[photoURLs[indexPath.row]])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedCellTag = indexPath.row
        self.performSegue(withIdentifier: "segueToLargeImage", sender: self)
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToLargeImage") {
            let photosVC: LargeImageViewController = segue.destination as! LargeImageViewController
            photosVC.tempURL = largePhotoURLs[tappedCellTag]
        }
    }
    
    func onCellButtonTap(sender: MyTableViewCell) {
        sender.MyCellLable.text = photoURLs[sender.tag].absoluteString
    }

}

