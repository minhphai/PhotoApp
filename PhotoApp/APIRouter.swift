//
//  APIRouter.swift
//  PhotoApp
//
//  Created by Phai Minh Hoang on 3/29/17.
//  Copyright © 2017 GotIt. All rights reserved.
//

import Foundation
import Alamofire




enum APIRouter:URLRequestConvertible  {
    
    case getGeoPhoto(lat:Double, lon:Double, page:Int, radius:Int )

    
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getGeoPhoto: return .get
            
        }
    }

    var parameters: [String:AnyObject] {
        switch self {
        case .getGeoPhoto(let lat, let lon, let page, let radius):
            return ( ["lat": lat as AnyObject,
                      "lon": lon as AnyObject,
                      "page": page as AnyObject,
                      "method":"flickr.photos.search" as AnyObject,
                      "api_key": "57d9b4f545bb44ce4e12a7c352f1896f" as AnyObject,
                      "radius":radius as AnyObject,
                      "accuracy":16 as AnyObject,
                      "nojsoncallback":1 as AnyObject,
                      "format":"json" as AnyObject,
                      "per_page":20 as AnyObject,
                      "extras":"geo" as AnyObject])
        }
    }
    
    
    
    func asURLRequest() throws -> URLRequest {

        var urlRequest = URLRequest(url: Configure.APIURL)
        urlRequest.httpMethod =  method.rawValue
        switch self {
        case .getGeoPhoto(_, _, _, _):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
