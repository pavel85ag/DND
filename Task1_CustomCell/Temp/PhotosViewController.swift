//
//  PhotosViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 9/13/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
      var photoURLs: [URL]!

      @IBOutlet weak var imageScrollView: UIScrollView!
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        for url in self.photoURLs {
//            let urlRequest = URLRequest(url: url)
//            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) -> Void in
//                let image = UIImage(data: data!)
//                self.addImageToView(image!)
//            })
//        }
//    }
//
//    func addImageToView(_ image: UIImage) {
//        let imageView: UIImageView = UIImageView(image: image)
//        let width = self.imageScrollView.frame.width
//        let imageRatio = image.size.width / image.size.height
//        let height = width / imageRatio
//        let x: CGFloat = 0
//        let y = self.imageScrollView.contentSize.height
//        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
//        let newHeight: CGFloat = self.imageScrollView.contentSize.height + height
//        self.imageScrollView.contentSize = CGSize(width: 320, height: newHeight)
//        self.imageScrollView.addSubview(imageView)
//    }
//
    
}
