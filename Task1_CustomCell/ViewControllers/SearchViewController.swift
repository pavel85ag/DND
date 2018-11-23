//
//  SearchViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 11/8/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ImagePropTableViewCellButtonDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addNameSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ImagePropTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageProp")
        searchTextField.delegate = self
        
        addNameSegmentedControl.selectedSegmentIndex = userDefaults.integer(forKey: "selectedSection")
        
        loadSavedToFavorits()
    }
    
    
    // MARK: Interface actions
    
    
    @IBAction func segmentedControllChanged(_ sender: UISegmentedControl) {
        userDefaults.set(sender.selectedSegmentIndex, forKey: "selectedSection")
    }
    
    
    @IBAction func searchButtonTap(_ sender: UIButton) {
        let searchText = searchTextField.text
        self.searchButton.isEnabled = false
        searchNewPhotos(forText: searchText!, completion: { self.tableView.reloadData()
                                                            self.searchButton.isEnabled = true
        })
        
    }
    
    
    func onCellButtonTap(sender: ImagePropTableViewCell) {
        
        let indexOfTappedCell = sender.tag
        
        if addNameSegmentedControl.selectedSegmentIndex == 0 {
            let alertController = UIAlertController(title: "Add name", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in let firstTextField = alertController.textFields![0] as UITextField
                
                sender.favoritsButton.isSelected = false
                sender.favoritsButton.isEnabled = false
                let name = firstTextField.text!
                addToFavoritsAndSave(index: indexOfTappedCell, name: name)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action : UIAlertAction!) -> Void in })
            alertController.addTextField { (textField : UITextField!) -> Void in textField.placeholder = "Enter image name"}
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            sender.favoritsButton.isSelected = false
            sender.favoritsButton.isEnabled = false
            let name = ""
            addToFavoritsAndSave(index: indexOfTappedCell, name: name)
            
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchButton.sendActions(for: .touchUpInside)
        
        return true
    }
    
    
    // MARK: TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedPhotos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageProp", for: indexPath) as! ImagePropTableViewCell
        cell.tag = indexPath.row
        cell.delegateCellButtonTap = self
        cell.backgroundColor = UIColor.clear
        
        loadImageForSearchTable(url: searchedPhotos[indexPath.row].smallPhotoURL!, for: indexPath, in: tableView)
        if searchedPhotos[indexPath.row].gpsAvailable == true {
            cell.gpsLabel.text = "Available"
        } else {
            cell.gpsLabel.text = "Not found"
        }
        cell.givenNameLabel.text = searchedPhotos[indexPath.row].givenName
        cell.latitudeLabel.text = String(searchedPhotos[indexPath.row].latitude)
        cell.longitudeLabel.text = String(searchedPhotos[indexPath.row].longitude)
        if searchedPhotos[indexPath.row].isFavorit == true {
            cell.favoritsButton.isSelected = false
            cell.favoritsButton.isEnabled = false
        } else {
            cell.favoritsButton.isSelected = true
            cell.favoritsButton.isEnabled = true
        
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPhotoWithProp = searchedPhotos[indexPath.row]
    }
    

 

}
