//
//  PhotosViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 9/13/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static var cachedImages = [URL : UIImage]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritsTableViewCell
        cell.tag = indexPath.row
        
        let url = favoritURLs[favoritURLs.count - indexPath.row - 1].smallImageURL
        var image: UIImage? = nil
        if let cachedImage = SmallImagesTableViewController.cachedImages[url] {
            image = cachedImage
            cell.optionalImage = image
        } else {
            loadImageForFavoritsTable(url: url, for: indexPath, in: tableView)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
                favoritURLs.remove(at: favoritURLs.count - indexPath.row - 1)
            })
            
            
        } else if editingStyle == .insert {
            
        }
    }
   
   
    
}
