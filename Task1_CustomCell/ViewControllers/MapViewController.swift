//
//  MapViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 10/24/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        
        let regionRadius: CLLocationDistance = 800000
        let currentCoordinate = CLLocationCoordinate2D(latitude: currentPhotoWithProp.latitude, longitude: currentPhotoWithProp.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currentCoordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        if currentPhotoWithProp.gpsAvailable == true {
            let pinAnnotation = makePinFromStruct(currentPhotoWithProp)
            mapView.addAnnotation(pinAnnotation)
        }

        for i in 0..<FavoritsViewController.favoritsPhotos.count {
            let pinAnnotation = makePinFromStruct(FavoritsViewController.favoritsPhotos[i])
            mapView.addAnnotation(pinAnnotation)

        }
    }

    
}




