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
import QuartzCore


// MARK: - Custom pin for map

class PinAnnotationImage: NSObject, MKAnnotation {
    
    let title: String?
    let id: String
    let coordinate: CLLocationCoordinate2D
    let pinImage: UIImage?
    
    init(title: String, coordinate: CLLocationCoordinate2D, image: UIImage?, id: String) {
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
            
            if let gotImage = pinAnnotation.pinImage {
                image = gotImage
            }
            
            
            centerOffset = CGPoint(x: (image?.size.width)!/2, y: -(image?.size.height)!/2)
        }
    }
}


// MARK: - Animation for cell

let TipInCellAnimatorStartTransform:CATransform3D = {
    let rotationDegrees: CGFloat = -180.0
    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(Double.pi)/180.0)
    let offset = CGPoint(x: 0, y: 0)
    var startTransform = CATransform3DIdentity
    startTransform = CATransform3DRotate(CATransform3DIdentity, rotationRadians, 0.0, 1.0, 0.0)
    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0)
    
    return startTransform
}()

class TipInCellAnimator {
    class func animate(cell:UITableViewCell) {
        let view = cell.contentView
            
            view.layer.transform = TipInCellAnimatorStartTransform
            view.layer.opacity = 0.8
            
        UIView.animate(withDuration: 0.4) {
                view.layer.transform = CATransform3DIdentity
                view.layer.opacity = 1
            }
        
    }
}


