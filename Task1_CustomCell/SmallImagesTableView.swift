
import UIKit
import FlickrKit


struct cellData {
    
    var text : String
    let image :  UIImage
    
}





class SmallImagesTableViewController: UITableViewController, mycellButtonDelegate {
    
    var photoURLs: [URL]!
     var arrayOfCellData = [cellData]()
    
    var cachedImages = [URL : UIImage]()
    var loadInProgress = [URL]()
    
    func onCellButtonTap(sender: MyTableViewCell) {
        
       
       sender.MyCellLable.numberOfLines = 7
       sender.MyCellLable.text = arrayOfCellData[sender.tag].text
    }
    
  

    override func viewDidLoad() {
        print("viewDidLoading")
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "Ident")
        
        arrayOfCellData.removeAll()
    }
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("setting number of rows")
        return photoURLs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("adding cells")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ident", for: indexPath) as! MyTableViewCell
        
        cell.MyCellLable.text = "Click to get URL"   //arrayOfCellData[indexPath.row].text
        cell.tag = indexPath.row
        cell.delegateCustom = self
        
        let url = photoURLs[indexPath.row]
        var image: UIImage? = nil
        if let cachedImage = cachedImages[url] {
            image = cachedImage
        } else {
            loadImage(url: url, for: indexPath)
        }
        
        cell.customImage = image
        
        return cell
    }
    
    func loadImage(url: URL, for indexPath: IndexPath) {
        guard !loadInProgress.contains(url) else { return }
        
        loadInProgress.append(url)
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self.cachedImages[url] = image
                    DispatchQueue.main.async {
                        self.updateCell(image: image, indexPath: indexPath)
                    }
                }
            }
        }
    }

    func updateCell(image: UIImage?, indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MyTableViewCell {
            cell.customImage = image
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         print("setting height")
        
        var imageWidth  = Int(240)
        var imageHeight = Int(120)
        
        if let cachedImage = cachedImages[photoURLs[indexPath.row]] {
            imageWidth  = Int(cachedImage.size.width)
            imageHeight = Int(cachedImage.size.height)
        }

       

     
            return (CGFloat((240*imageHeight/imageWidth) + 20))
     
        
       
    }
    
    

}

