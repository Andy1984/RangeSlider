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
    @IBOutlet weak var steppedSlider: RangeSlider!
    @IBOutlet weak var stepByStepSlider: RangeSlider!
    @IBOutlet weak var crossoverSlider: RangeSlider!
    
    
    
    
    
    
    
    @IBAction func updateValues(_ sender: Any) {
        let value1 = Double(arc4random_uniform(100))/100.0
        let value2 = Double(arc4random_uniform(100))/100.0
        setValuesSlider.minimumValue = 0
        setValuesSlider.maximumValue = 1
        setValuesSlider.setValue(low: min(value1, value2), high: max(value1, value2), animated: true)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBasicSlider()
        setupSetValuesAnimatedSlider()
        setupSteppedSlider()
        setupStepByStepSlider()
        setupCrossoverSlider()
    }
    
    func setupBasicSlider() {
        basicSlider.minimumValue = 0
        basicSlider.maximumValue = 1
    }
    
    func setupSetValuesAnimatedSlider() {
        setValuesSlider.lowMaximumValue = 0.5
        setValuesSlider.highValue = 0.8
    }
    
    func setupSteppedSlider() {
        steppedSlider.stepValue = 0.2
    }
    
    func setupStepByStepSlider() {
        stepByStepSlider.stepValue = 0.2
        stepByStepSlider.isMovingStepByStep = true
    }
    
    func setupCrossoverSlider() {
        crossoverSlider.maximumValue = 1
        crossoverSlider.minimumValue = -1
        crossoverSlider.minimumDistance = -2
    }
    
}
