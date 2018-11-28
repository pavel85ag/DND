//
//  PhotoDetailViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 11/15/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoIDLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    let picker = UIImagePickerController()
    lazy var rotationCounter = Float(1000)
    var loadingFromLib = Bool(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(switchToMap))
        swipe.direction = .down
        swipe.numberOfTouchesRequired = 2
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
        
        imageView.isUserInteractionEnabled = true
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateElement))
        imageView.addGestureRecognizer(rotationGesture)
        rotationGesture.delegate = self
    }
    @objc func switchToMap () {
        tabBarController!.selectedIndex = 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if loadingFromLib == false {
            if let url = currentPhotoWithProp.largePhotoURL {
                imageView.image = loadImageForUrl(url, scale: 1.0)
                nameLabel.text = currentPhotoWithProp.givenName
                photoIDLabel.text = currentPhotoWithProp.photo_id
                latitudeLabel.text = String(currentPhotoWithProp.latitude)
                longitudeLabel.text = String(currentPhotoWithProp.longitude)
            }
        } else {
            nameLabel.text = currentPhotoWithProp.givenName
            photoIDLabel.text = currentPhotoWithProp.photo_id
            latitudeLabel.text = String(currentPhotoWithProp.latitude)
            longitudeLabel.text = String(currentPhotoWithProp.longitude)
        }
        loadingFromLib = false
        
    }
    
    
    //MARK: Rotation methods
    
    @objc func rotateElement(sender: UIRotationGestureRecognizer){
        
        var rotationDefiner = Int()
        var orientation = UIImageOrientation(rawValue: 0)
        
        rotationCounter = rotationCounter + Float(sender.rotation * 2)
        sender.rotation = 0
        
        rotationDefiner = (Int(rotationCounter) % 4)
        switch rotationDefiner {
        case 0 : orientation = UIImageOrientation.up
        case 1 : orientation = UIImageOrientation.right
        case 2 : orientation = UIImageOrientation.down
        case 3 : orientation = UIImageOrientation.left
        default:
            orientation = UIImageOrientation.up
        }
        
        if let image = self.imageView.image {
            if let cgImage  = image.cgImage {
                let newImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation!)
                self.imageView.image = newImage
            }
        }
    }
    
  
    // MARK: Load from Lib / Save to Lib
    
    
    @IBAction func saveToLib(_ sender: UIBarButtonItem) {
        if let image = self.imageView.image {
            
            let alert = UIAlertController(title: "Saved", message: "Image is saved to library", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            
        }
    }
    
    
    @IBAction func openLib(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        loadingFromLib = true
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = chosenImage
        
        let asset = info[UIImagePickerControllerPHAsset] as! PHAsset
        print(asset)
        if let coordinate = asset.location?.coordinate {
            let tempStruct = PhotoUrlAndProperties(smallPhotoURL: nil, largePhotoURL: nil, photo_id: "", givenName: "", gpsAvailable: true, latitude: coordinate.latitude, longitude: coordinate.longitude, isFavorit: false)
            currentPhotoWithProp = tempStruct
        } else {
            let tempStruct = PhotoUrlAndProperties(smallPhotoURL: nil, largePhotoURL: nil, photo_id: "", givenName: "", gpsAvailable: false, latitude: 0.0, longitude: 0.0, isFavorit: false)
            currentPhotoWithProp = tempStruct
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
