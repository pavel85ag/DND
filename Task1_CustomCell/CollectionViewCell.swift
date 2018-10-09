//
//  CollectionViewCell.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 9/26/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var optionalImage: UIImage? {
        didSet {
            collectionCellImageView.image = optionalImage
            if optionalImage == nil {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBOutlet weak var collectionCellImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}
