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
    @IBOutlet weak var steppedContinuouslySlider: RangeSlider!
    @IBOutlet weak var crossoverSlider: RangeSlider!
    @IBOutlet weak var programmaticSlider: RangeSlider!
    @IBOutlet weak var customThemeSlider: RangeSlider!
    @IBOutlet weak var singleThumbSlider: RangeSlider!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupBasicSlider()
        setupSetValuesAnimatedSlider()
        setupSteppedSlider()
        setupSteppedContinuouslySlider()
        setupCrossoverSlider()
        setupProgrammaticSlider()
        setupCustomThemeSlider()
        setupSingleThumbSlider()
    }
    
    func setupCustomThemeSlider() {
        customThemeSlider.trackBackgroundImage = #imageLiteral(resourceName: "hollowProgress").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5, 0, 5))
        customThemeSlider.trackImage = #imageLiteral(resourceName: "solidProgress").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5, 0, 5))
        customThemeSlider.lowHandleImageNormal = #imageLiteral(resourceName: "smile")
        customThemeSlider.lowHandleImageHighlighted = #imageLiteral(resourceName: "kiss")
        customThemeSlider.highHandleImageNormal = #imageLiteral(resourceName: "love")
        customThemeSlider.highHandleImageHighlighted = #imageLiteral(resourceName: "mask")
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
        setValuesSlider.lowValue = 0.5
        setValuesSlider.highValue = 0.8
        setValuesSlider.lowHandleImageNormal = #imageLiteral(resourceName: "smile")
        setValuesSlider.highHandleImageNormal = #imageLiteral(resourceName: "love")
    }
    
    func setupSteppedSlider() {
        steppedSlider.stepValue = 0.25
        steppedSlider.lowHandleImageNormal = #imageLiteral(resourceName: "smile")
        steppedSlider.highHandleImageNormal = #imageLiteral(resourceName: "love")
    }
    
    func setupSteppedContinuouslySlider() {
        steppedContinuouslySlider.stepValue = 0.25
        steppedContinuouslySlider.stepValueContinuously = true
        steppedContinuouslySlider.lowHandleImageNormal = #imageLiteral(resourceName: "smile")
        steppedContinuouslySlider.highHandleImageNormal = #imageLiteral(resourceName: "love")
    }
    
    func setupCrossoverSlider() {
        crossoverSlider.maximumValue = 1
        crossoverSlider.minimumValue = -1
        crossoverSlider.minimumDistance = -2
        crossoverSlider.lowHandleImageNormal = #imageLiteral(resourceName: "smile")
        crossoverSlider.highHandleImageNormal = #imageLiteral(resourceName: "love")
    }
    
    func setupProgrammaticSlider() {
        // magenta value bar and height is 5.0
        let trackImage = RangeSlider.getImage(color: .magenta, rect: CGRect(x: 0, y: 0, width: 1, height: 5))
        programmaticSlider.trackImage = trackImage
        
        // brown background bar and height is 5.0
        let trackBackgroundImage = RangeSlider.getImage(color: .brown, rect: CGRect(x: 0, y: 0, width: 1, height: 5))
        programmaticSlider.trackBackgroundImage = trackBackgroundImage
        
        programmaticSlider.lowValue = 0.25
    }
    
    func setupSingleThumbSlider() {
        
        singleThumbSlider.highValue = 0.0
        singleThumbSlider.highHandleImageNormal = #imageLiteral(resourceName: "smile")
        singleThumbSlider.trackBackgroundImage = #imageLiteral(resourceName: "hollowProgress").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5, 0, 5))
        singleThumbSlider.trackImage = #imageLiteral(resourceName: "solidProgress").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5, 0, 5))
        singleThumbSlider.isLowHandleHidden = true
        singleThumbSlider.stepValue = 0.25
        singleThumbSlider.stepValueContinuously = true
    }
    
}
