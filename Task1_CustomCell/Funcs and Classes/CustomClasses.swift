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

// MARK: - Custom pin for map

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    init(location: CLLocationCoordinate2D) {
        self.coordinate = location
    }
    
    
}


