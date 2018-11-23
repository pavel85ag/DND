//
//  customClasses.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 10/25/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import Photos
import Contacts

// MARK: - Custom pin for map

class PinAnnotationImage: NSObject, MKAnnotation {
    
    let title: String?
    let id: String
    let coordinate: CLLocationCoordinate2D
    let pinImage: UIImage
    
    init(title: String, coordinate: CLLocationCoordinate2D, image: UIImage, id: String) {
        self.title = title
        self.id = id
        self.coordinate = coordinate
        self.pinImage = image
        
        super.init()
    }
    
    var subtitle: String? {
        return "Lat \(String(coordinate.latitude)) Lon \(String(coordinate.longitude)) "
    }
}


class PinAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let pinAnnotation = newValue as? PinAnnotationImage else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 0)
            //rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            image = pinAnnotation.pinImage
            
        }
    }
}






