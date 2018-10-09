

import UIKit

protocol MyTableViewCellButtonDelegate: class {
    func onCellButtonTap (sender: MyTableViewCell)
}

class MyTableViewCell: UITableViewCell {
    
    weak var delegateCellButtonTap : MyTableViewCellButtonDelegate?
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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var MyCellImageView: UIImageView!
    @IBOutlet weak var MyCellButton: UIButton!
    @IBOutlet weak var MyCellLable: UILabel!
    
    func onCellButtonTap (sender: MyTableViewCell){
        delegateCellButtonTap?.onCellButtonTap(sender: self)
    }
    
    @IBAction func cellButtonTap(_ sender: UIButton) {
        onCellButtonTap(sender: self)
    }
    
}

