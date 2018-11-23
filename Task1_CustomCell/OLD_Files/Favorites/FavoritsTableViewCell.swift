//
//  FavoritsTableViewCell.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 10/12/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit

class FavoritsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoritsTVCellImageView: UIImageView!
    
    var optionalImage: UIImage? {
        didSet {
            favoritsTVCellImageView.image = optionalImage
            if optionalImage == nil {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

}
