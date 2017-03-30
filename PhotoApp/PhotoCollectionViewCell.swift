//
//  PhotoCollectionViewCell.swift
//  PhotoApp
//
//  Created by Phai Minh Hoang on 3/29/17.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CollectionViewCell"
    
    @IBOutlet weak var imgView: UIImageView! {
        didSet {
            imgView.layer.cornerRadius = 8.0
            imgView.clipsToBounds =  true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.backgroundColor = UIColor.blue
    }
    
    func configure(thumbnail:URL?) {
        imgView.image = UIImage(named: "defaultImage")
        if let URL = thumbnail {
            imgView.af_setImage(withURL: URL)
        }
    }
}
