//
//  ViewController.swift
//  YWCRangeSlider
//
//  Created by YangWeicheng on 15/05/2017.
//  Copyright © 2017 YWC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YWCRangeSlider"
        
        let basicSlider = RangeSlider(frame: CGRect(x: 50, y: 64, width: 300, height: 50));
        view.addSubview(basicSlider);
        
        let minimumRangeNegativeSlider = RangeSlider(frame: CGRect(x: 50, y: 64 + 50, width: 300, height: 50));
        minimumRangeNegativeSlider.minimumRange = -1;
        view.addSubview(minimumRangeNegativeSlider);
        
    }
    
}
