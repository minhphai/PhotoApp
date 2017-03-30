//
//  PhotoViewController.swift
//  PhotoApp
//
//  Created by Phai Minh Hoang on 3/28/17.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class PhotoViewController: UIViewController, CLLocationManagerDelegate, DataEnteredDelegate {
    
    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var leftView: UIView! {
        didSet {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.leftViewTapped(gestureRecognizer:)))
            //gestureRecognizer.delegate = self
            leftView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @IBOutlet weak var rightView: UIView! {
        didSet {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.rightViewTapped(gestureRecognizer:)))
            //gestureRecognizer.delegate = self
            rightView.addGestureRecognizer(gestureRecognizer)
        }
    }
    @IBOutlet weak var indicatorView: UIActivityIndicatorView! {
        didSet {
            indicatorView.color = UIColor.gray
            indicatorView.isHidden =  true
        }
    }
    var isLoading                       = false
    var isFirstLoading                  = true
    let locationManager = CLLocationManager()
    var currentLat:Double!
    var currentLon:Double!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var photoList:[FlickrPhoto] = []
    var totalPages:Int!
    var currentPage = 1
    var currentRadius = 5
    override func viewDidLoad() {
        super.viewDidLoad()


        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        

    }
    
 

    func rightViewTapped(gestureRecognizer: UIGestureRecognizer) {
        
        self.performSegue(withIdentifier: "goToSettingSegue", sender: nil)
    }

    func leftViewTapped(gestureRecognizer: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "goToMapViewSegue", sender: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.contentInset.bottom = 30
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLat = location.coordinate.latitude
            currentLon = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
            loadNextPage()
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    func loadNextPage() {
        if isLoading  { return }
        
        if (totalPages != nil) && currentPage > totalPages {
            return
        }
        
        isLoading = true
        if self.isFirstLoading {
            self.indicatorView.isHidden =  true
            //self.showWaitOverlay()
        } else {
            self.indicatorView.isHidden = !self.isLoading
        }
        //indicatorView.isHidden = !isLoading
        indicatorView.startAnimating()
        
        
        
        DispatchQueue.global().async {
            
            sleep(1)
             APIManager.sharedInstance.getGeoPhotos(lat: self.currentLat, lon: self.currentLon, page: self.currentPage, radius: self.currentRadius) { pages,photos in
                if pages == 0 {
                    self.isLoading = false
                    self.indicatorView.isHidden = true
                    self.indicatorView.stopAnimating()
                    self.isFirstLoading = false
                    return
                }
                self.totalPages = pages
                self.currentPage = self.currentPage + 1
                for item in photos {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else { return }

                        self.photoList.append(item)
                        //self.removeAllOverlays()
                        let indexPath = IndexPath(row: self.photoList.count - 1, section: 0)
                        self.collectionView.insertItems(at: [indexPath])
                        //self.tableView.insertRows(at: , with: .bottom)
                        
                        self.isLoading = false
                        if self.isFirstLoading {
                            self.indicatorView.isHidden =  true
                        }
                        self.indicatorView.isHidden = !self.isLoading
                        self.indicatorView.stopAnimating()
                        self.isFirstLoading = false
                    }
                }
                
            }
        }
        
        
    }
    
    func doubleTapped(selectedIndex: IndexPath) {
        print("Double Tap")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
            
        case "goToSettingSegue":
            let nextVC     = segue.destination as! FilterViewController
            nextVC.delegate = self
            nextVC.distance = currentRadius
        default:
            break
        }
    }
    

    
    func userDidEnter(distance: Int) {
        photoList.removeAll()
        currentPage = 1
        collectionView.reloadData()
        currentRadius = distance
        loadNextPage()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoViewController:UICollectionViewDataSource {
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! PhotoCollectionViewCell

        cell.configure(thumbnail: photoList[indexPath.row].thumbnail)

        return cell
    }
    

}

extension PhotoViewController:UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let bottomOffset = offsetY + scrollView.bounds.size.height
        
        if bottomOffset >= scrollView.contentSize.height {
            loadNextPage()
        }
        
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            
            let offsetY = scrollView.contentOffset.y
            let bottomOffset = offsetY + scrollView.bounds.size.height
            
            if bottomOffset >= scrollView.contentSize.height {
                loadNextPage()
            }
        }
    }
}

extension PhotoViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
