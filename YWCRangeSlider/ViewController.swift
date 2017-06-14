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
    @IBOutlet weak var programmaticSlider: RangeSlider!
    @IBOutlet weak var metalThemeSlider: RangeSlider!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBasicSlider()
        setupSetValuesAnimatedSlider()
        setupSteppedSlider()
        setupStepByStepSlider()
        setupCrossoverSlider()
        setupProgrammaticSlider()
        setupMetalThemeSlider()
    }
    
    func setupMetalThemeSlider() {
        metalThemeSlider.trackBackgroundImage = #imageLiteral(resourceName: "slider-metal-trackBackground.png").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5, 0, 5))
        metalThemeSlider.trackImage = #imageLiteral(resourceName: "slider-metal-track.png").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 7, 0, 7))
        metalThemeSlider.lowHandleImageNormal = #imageLiteral(resourceName: "smile")
        metalThemeSlider.lowHandleImageHighlighted = #imageLiteral(resourceName: "kiss")
        metalThemeSlider.highHandleImageNormal = #imageLiteral(resourceName: "love")
        metalThemeSlider.highHandleImageHighlighted = #imageLiteral(resourceName: "mask")
    }
    
    @IBAction func updateValues(_ sender: Any) {
        let value1 = Double(arc4random_uniform(100)) / 100.0
        let value2 = Double(arc4random_uniform(100)) / 100.0
        setValuesSlider.minimumValue = 0
        setValuesSlider.maximumValue = 1
        setValuesSlider.setValue(low: min(value1, value2), high: max(value1, value2), animated: true)
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
    
    func setupProgrammaticSlider() {
        programmaticSlider.lowValue = 0.3
        programmaticSlider.highValue = 0.9
    }
    
}
