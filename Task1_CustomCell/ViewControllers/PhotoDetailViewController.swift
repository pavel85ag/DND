//
//  PhotoDetailViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 11/15/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoIDLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(switchToMap))
        swipe.direction = .down
        swipe.numberOfTouchesRequired = 2
        swipe.delegate = self
        
        view.addGestureRecognizer(swipe)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = currentPhotoWithProp.largePhotoURL {
            imageView.image = loadImageForUrl(url, scale: 1.0)
            nameLabel.text = currentPhotoWithProp.givenName
            photoIDLabel.text = currentPhotoWithProp.photo_id
            latitudeLabel.text = String(currentPhotoWithProp.latitude)
            longitudeLabel.text = String(currentPhotoWithProp.longitude)
            
        }
    }
    
    
    @objc func switchToMap () {
        tabBarController!.selectedIndex = 3
    }

}
