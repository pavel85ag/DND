//
//  StoredImgWithGeoViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 10/26/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
import CoreData

class StoredImgWithGeoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tappedCellTag = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImgsWithGeo")
        do {
            itemsToSave = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("failed to fetch", error)
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToSave.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let item = itemsToSave[indexPath.row]
        
        let latitude = item.value(forKeyPath: "latitude") as! Double
        let longitude = item.value(forKeyPath: "longitude") as! Double
        let str = "Lat: " + latitude.description + " Long: " + longitude.description
        
        let imageData = item.value(forKeyPath: "image") as! NSData
        let image = UIImage(data: imageData as Data, scale: 1)
        
        cell.textLabel?.text = str
        cell.imageView?.image = image
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImgsWithGeo")
            let objects = try! managedContext.fetch(fetchRequest)
            
            tableView.performBatchUpdates({
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                managedContext.delete(objects[indexPath.row])
                
                do {
                    try managedContext.save()
                    itemsToSave.remove(at: indexPath.row)
                } catch let error as NSError {
                    print("failed to save", error)
                }
                
            })
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedCellTag = indexPath.row
        self.performSegue(withIdentifier: "backToCollection", sender: self)
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "backToCollection") {
            let item = itemsToSave[tappedCellTag]
                        
            let latitude = item.value(forKeyPath: "latitude") as! Double
            let longitude = item.value(forKeyPath: "longitude") as! Double
            
            let imageData = item.value(forKeyPath: "image") as! NSData
            let image = UIImage(data: imageData as Data, scale: 1)
            
            updateCurrentImgWithGeo(image: image!, latitude: latitude, longitude: longitude)
        
        }
        
    }

    
    
}
