//
//  FlickrPhoto.swift
//  PhotoApp
//
//  Created by Phai Minh Hoang on 3/29/17.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

import UIKit
import SwiftyJSON

class FlickrPhoto {
    var thumbnail : URL?
    let photoID : String
    let farm : Int
    let server : String
    let secret : String
    let title : String
    let lat:Double
    let lon:Double
    init?(json:SwiftyJSON.JSON) {
        if let id = json["id"].string {
            self.photoID =  id
        } else { return nil}
        
        farm        = json["farm"].int!
        secret      = json["secret"].string!
        server      = json["server"].string!
        title       = json["title"].string!
        lat         = Double(json["latitude"].string!)!
        lon         = Double(json["longitude"].string!)!
        thumbnail = flickrImageURL()
    }
    
    func flickrImageURL(_ size:String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }

}
