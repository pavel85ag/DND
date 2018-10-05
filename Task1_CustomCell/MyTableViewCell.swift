

import UIKit

protocol MyTableViewCellButtonDelegate: class {
    func onCellButtonTap (sender: MyTableViewCell)
}

protocol MyTableViewCellImageDelegate: class {
    func onCellImageTap (sender: Any?)
}


class MyTableViewCell: UITableViewCell {
    
    

    weak var delegateCellButtonTap : MyTableViewCellButtonDelegate?
    weak var delegateCellImageTap : MyTableViewCellImageDelegate?
    
    func onCellButtonTap (sender: MyTableViewCell){
        delegateCellButtonTap?.onCellButtonTap(sender: self)
    }
    
    @objc func onCellImageTap (sender: MyTableViewCell){
        delegateCellImageTap?.onCellImageTap(sender: self)
    }
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var MyCellImageView: UIImageView!
    
    @IBOutlet weak var MyCellButton: UIButton!
    
    @IBOutlet weak var MyCellLable: UILabel!
    
    var optionalImage: UIImage? {
        didSet {
            MyCellImageView.image = optionalImage
            if optionalImage == nil {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
   
    
    @IBAction func myCellButtonClick(_ sender: UIButton) {
        
       onCellButtonTap(sender: self)
      
        
    }
    
    
}

