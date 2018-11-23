//
//  ImagePropTableViewCell.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 11/9/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit

protocol ImagePropTableViewCellButtonDelegate: class {
    func onCellButtonTap (sender: ImagePropTableViewCell)
}


class ImagePropTableViewCell: UITableViewCell {
   
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoritsButton: UIButton!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    weak var delegateCellButtonTap : ImagePropTableViewCellButtonDelegate?
    
    var optionalImage: UIImage? {
        didSet {
            imageV.image = optionalImage
            if optionalImage == nil {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func onCellButtonTap (sender: ImagePropTableViewCell){
        delegateCellButtonTap?.onCellButtonTap(sender: self)
    }
    
    
    @IBAction func favoritsButtonTap(_ sender: UIButton) {
        onCellButtonTap(sender: self)
    }
    
    
    
}
