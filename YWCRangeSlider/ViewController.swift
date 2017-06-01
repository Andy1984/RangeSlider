//
//  ViewController.swift
//  YWCRangeSlider
//
//  Created by YangWeicheng on 15/05/2017.
//  Copyright © 2017 YWC. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBOutlet weak var basicSlider: RangeSlider!
    @IBOutlet weak var setValuesSlider: RangeSlider!
    @IBAction func updateValues(_ sender: Any) {
        let value1 = Double(arc4random())/Double(RAND_MAX)
        let value2 = Double(arc4random())/Double(RAND_MAX)
        // where 2 values are very close, the ball is 100% immobile.
        // and it is not animated
        setValuesSlider.setValue(low: min(value1, value2), high: max(value1, value2), animated: true)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        title = "YWCRangeSlider"
//        
//        let basicSlider = RangeSlider(frame: CGRect(x: 50, y: 264, width: 300, height: 50));
//        basicSlider.isLabelHidden = false
//        view.addSubview(basicSlider);
//        
//        let minimumRangeNegativeSlider = RangeSlider(frame: CGRect(x: 50, y: 64 + 50, width: 300, height: 50));
//        minimumRangeNegativeSlider.minimumDistance = -1;
//        view.addSubview(minimumRangeNegativeSlider);
//        
//        let stepRangSlider = RangeSlider(frame: CGRect(x: 50, y: 64 + 100, width: 300, height: 50))
//        stepRangSlider.stepValue = 0.2
//        stepRangSlider.isMovingStepByStep = true
//        view.addSubview(stepRangSlider)
    }
    
}
