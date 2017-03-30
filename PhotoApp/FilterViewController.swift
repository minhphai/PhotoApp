//
//  FilterViewController.swift
//  PhotoApp
//
//  Created by Phai Minh Hoang on 3/30/17.
//  Copyright © 2017 GotIt. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    var distance:Int?
    weak var delegate: DataEnteredDelegate? = nil
    
    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.cyan
        if let radius = self.distance {
            distanceLabel.text = String(radius)
            slider.setValue(Float(radius), animated: true)
        }
        
        
    }

    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func changeDistance(_ sender: UISlider) {
        distanceLabel.text = String(Int(sender.value))
        distance = Int(sender.value)
        
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let dis = distance else {
            return
        }
        delegate?.userDidEnter(distance: dis)
        self.dismiss(animated: true, completion: nil)
    }

}
protocol DataEnteredDelegate: class {
    func userDidEnter(distance: Int)
}
