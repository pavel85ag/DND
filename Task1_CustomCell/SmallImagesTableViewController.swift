import UIKit
import FlickrKit


class SmallImagesTableViewController: UITableViewController, MyTableViewCellButtonDelegate  {
    
    
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
        if let cachedImage = cachedImages[url] {
            image = cachedImage
        } else {
            loadImageForTable(url: url, for: indexPath, in: tableView)
        }
        cell.optionalImage = image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateRowHeight(forImageInRow: cachedImages[photoURLs[indexPath.row]])
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

