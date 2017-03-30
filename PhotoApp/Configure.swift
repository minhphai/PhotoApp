//
//  Configure.swift
//  PhotoApp
//
//  Created by Phai Minh Hoang on 3/29/17.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit
import AlamofireImage

final class Configure {
    
    static let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
    
    static let APIURL = URL(string: "https://api.flickr.com/services/rest/")!
    static let FLICKR_API_KEY = "57d9b4f545bb44ce4e12a7c352f1896f"
    
    struct Color {
        static let background = UIColor(red: 31/255, green: 59/255, blue: 99/255, alpha: 1.0)
        static let bluesky = UIColor(red: 57/255, green: 139/255, blue: 221/255, alpha: 1.0)
    }
    
    struct Timing {
        static let loadNextPage:UInt32 = 1
    }
    
    
}

