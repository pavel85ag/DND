//
//  FavoritsViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 11/8/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore


class FavoritsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    static var favoritsPhotos = [PhotoUrlAndProperties]()
    var didAnimateCell:[NSIndexPath: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ImagePropTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageProp")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: Interface actions
    
    
    @IBAction func removeFavorits(_ sender: Any) {
        
        let managedContext = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageFullGeoProps")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            objectsToSave.removeAll()
        } catch let error as NSError {
            print("failed to save", error)
        }
        
        favoritPhoto_idDict.removeAll()
        FavoritsViewController.favoritsPhotos.removeAll()
        
        tableView.reloadData()
    }
    
    
    // MARK: TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritsViewController.favoritsPhotos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageProp", for: indexPath) as! ImagePropTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.tag = indexPath.row
        let index = FavoritsViewController.favoritsPhotos.count - indexPath.row - 1
        
        loadImageForSearchTable(url: FavoritsViewController.favoritsPhotos[index].smallPhotoURL!, for: indexPath, in: tableView)
        if FavoritsViewController.favoritsPhotos[index].gpsAvailable == true {
            cell.gpsLabel.text = "Available"
        } else {
            cell.gpsLabel.text = "Not found"
        }
        cell.givenNameLabel.text = FavoritsViewController.favoritsPhotos[index].givenName
        cell.latitudeLabel.text = String(FavoritsViewController.favoritsPhotos[index].latitude)
        cell.longitudeLabel.text = String(FavoritsViewController.favoritsPhotos[index].longitude)
        cell.favoritsButton.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let managedContext = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageFullGeoProps")
            let objects = try! managedContext.fetch(fetchRequest)
            
            tableView.performBatchUpdates({
                
                let index = FavoritsViewController.favoritsPhotos.count - indexPath.row - 1
                
                let photo_id = FavoritsViewController.favoritsPhotos[index].photo_id
                
                favoritPhoto_idDict.removeValue(forKey: photo_id)
                tableView.deleteRows(at: [indexPath], with: .fade)
                managedContext.delete(objects[index])
                FavoritsViewController.favoritsPhotos.remove(at: index)
                
                do {
                    try managedContext.save()
                    objectsToSave.remove(at: indexPath.row)
                } catch let error as NSError {
                    print("failed to save", error)
                }
                
            })
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPhotoWithProp = FavoritsViewController.favoritsPhotos[FavoritsViewController.favoritsPhotos.count - indexPath.row - 1]
        
    }
   

}
