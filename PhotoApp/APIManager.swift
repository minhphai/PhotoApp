//
//  APIManager.swift
//  PhotoApp
//
//  Created by Phai Minh Hoang on 3/29/17.
//  Copyright © 2017 GotIt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class APIManager {
    
    public class var sharedInstance: APIManager {
        struct Singleton {
            static let instance : APIManager = APIManager()
        }
        return Singleton.instance
    }
    
    let manager = Alamofire.SessionManager.default
    
    init() {
    }
    
    //MARK: methods
    
    //    {"error":"this username is already taken"}
    //    {"success":"user created"}%
    func getGeoPhotos(lat:Double,lon:Double, page:Int, radius:Int, completion:@escaping (Int,[FlickrPhoto]) -> ()) -> Request {
        let router = APIRouter.getGeoPhoto(lat: lat, lon: lon, page: page, radius: radius)
        return manager.request(router)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        if json["stat"].string == "fail" {
                            print("failed")
                            completion(0,[])
                        }
                        guard let pages = json["photos"]["pages"].int  else {
                            return
                        }
                        //let pages = json["photos"]["pages"].int!
                        var photos = [FlickrPhoto]()
                        for result in json["photos"]["photo"].arrayValue {
                            if let item = FlickrPhoto.init(json: result) {
                                photos.append(item)
                            }}
                        completion(pages,photos)
                    }
                case .failure(let error):
                    print(error)
                    completion(0,[])
                }
        }
    }
}
