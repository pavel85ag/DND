//
//  CollectionViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 9/26/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit


class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIDropInteractionDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var labelForURL: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoritTabBarItem: UITabBarItem!
    
    let picker = UIImagePickerController()
    lazy var rotationCounter = Float(1000)
    let barButtonItemSwitch = UISwitch()
    
    static var cachedImages = [URL : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelForURL.numberOfLines = 0
        labelForURL.isUserInteractionEnabled = true
        
        largeImageView.isUserInteractionEnabled = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonItemSwitch)
        
        let dropInteractionForLabel = UIDropInteraction(delegate: self)
        let dropInteractionForImage = UIDropInteraction(delegate: self)
        labelForURL.addInteraction(dropInteractionForLabel)
        largeImageView.addInteraction(dropInteractionForImage)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateElement))
        self.largeImageView.addGestureRecognizer(rotationGesture)
        rotationGesture.delegate = self
        
        let dTapGesture = UITapGestureRecognizer(target: self, action: #selector(addToFavorites))
        dTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(dTapGesture)
        dTapGesture.delegate = self
        
        picker.delegate = self
        
    }
    
    
//MARK: CollectionView methods
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 275, height: 178)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCVcell", for: indexPath) as? CollectionViewCell {
            let url = photoURLs[indexPath.row]
            var image: UIImage? = nil
            if let cachedImage = CollectionViewController.cachedImages[url] {
                image = cachedImage
                itemCell.optionalImage = image
            } else {
                loadImageForCollection(url: url, for: indexPath, in: collectionView)
            }
            
            return itemCell
        }
        else {
            
            return UICollectionViewCell()
        }
    }
    
    
//MARK: ScrollToItem methods
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(row: indexOfMajorCell(), section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if barButtonItemSwitch.isOn == false {
            targetContentOffset.pointee = scrollView.contentOffset
        }
        
        let indexPath = IndexPath(row: indexOfMajorCell(), section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    private func indexOfMajorCell() -> Int {
        
        let collectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = collectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(photoURLs.count - 1, index))
        
        return safeIndex
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
        
        if let image = self.largeImageView.image {
            if let cgImage  = image.cgImage {
                let newImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation!)
                self.largeImageView.image = newImage
            }
        }
    }
  
 
//MARK: DoubleTap for Favorites method
    
    @objc func addToFavorites (recognizer: UIGestureRecognizer) {
        
        let location = recognizer.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: location)
        if let _ = indexPath {
            collectionView.deselectItem(at: indexPath!, animated: true)
            if let index = indexPath?.row {
                let urlSet = favoritURL(smallImageURL: photoURLs[index], largeImageURL: largePhotoURLs[index])
                favoritURLs.append(urlSet)
                self.favoritTabBarItem.isEnabled = true
                
                UIView.animate(withDuration: 1.2) {
                    self.favoritTabBarItem.isEnabled = false
                }
            }
        }
        for i in 0..<favoritURLs.count - 1 {
            if favoritURLs[i].smallImageURL == favoritURLs[favoritURLs.count-1].smallImageURL{
                favoritURLs.remove(at: i)
                break
            }
        }
    }
    
    
    //MARK: Adding to Library/loading from library
    
    
    @IBAction func saveToLibrary(_ sender: Any) {
        if let image = self.largeImageView.image {
            
            let alert = UIAlertController(title: "Saved", message: "Image is saved to library", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
    }
    
    
    @IBAction func openLibrary(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        largeImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


//MARK: Extension for DragNDrop methods

extension CollectionViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("performDropWith")
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let data = largePhotoURLs[indexPath.row] as NSURL
        let url = data
        let itemProvider = NSItemProvider(object: url )
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        return[dragItem]
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: NSURL.self) { urlItems in
            let nsurl = urlItems as! [NSURL]
            
            if interaction.view == self.labelForURL as UIView {
                self.labelForURL.text = nsurl.first?.absoluteString
            }
            
            if interaction.view == self.largeImageView as UIView {
                let urlContents = try? Data(contentsOf: nsurl.first! as URL)
                if let imageData = urlContents {
                    self.largeImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    
}



