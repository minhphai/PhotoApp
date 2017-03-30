//
//  PhotoAnnotation.swift
//  PhotoApp
//
//  Created by Phai Minh Hoang on 3/30/17.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image:UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

}
