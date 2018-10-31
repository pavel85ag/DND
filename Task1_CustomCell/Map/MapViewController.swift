//
//  MapViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 10/24/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let regionRadius: CLLocationDistance = 800000
            let currentCoordinate = currentImageWithGeo.coordinate
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(currentCoordinate, regionRadius, regionRadius)
            map.setRegion(coordinateRegion, animated: true)
            let pin = customPin(location: currentCoordinate)
            map.addAnnotation(pin)
        
    }

    
}
