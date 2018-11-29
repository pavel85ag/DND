//
//  MapViewController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 10/24/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
    
    
    @IBAction func findMeOnMap(_ sender: UIBarButtonItem) {
        if CLLocationManager.locationServicesEnabled() {
            print("IS Enabled")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            print("Finished")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 600, 600)
        self.mapView.setRegion(viewRegion, animated: true)
        
    }
    
}




