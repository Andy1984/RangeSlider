//
//  RangeSlider.swift
//  YWCRangeSlider
//
//  Created by YangWeicheng on 15/05/2017.
//  Copyright © 2017 YWC. All rights reserved.
//

import UIKit

class RangeSlider: UIControl {
    
    
    /// default 0.0
    var minimumValue = 0.0
    
    /// default 1.0
    var maximumValue = 1.0
    
    /// defalut 0.0 The minimum distance between the low value and higher value
    var minimumRange = 0.0
    
    var stepValueContinuously = false
    
    var lowValue = 0.0
    var higherValue = 0.0
    
    ///  maximum value for left thumb
    var lowMaximumValue = 0.0
    
    /// minimum value for right thumb
    var higherMinimumValue = 0.0
    
    var lowTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5)
    let higherTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5)
    
    var trackImageView: UIImageView!
    var trackBackgroundImageView: UIImageView!
    var lowHandle: UIImageView!
    var higherHandle: UIImageView!
    private var lowCenter: CGPoint!
    private var higherCenter: CGPoint!
    
    
    
    var defaultHandleImage: UIImage = #imageLiteral(resourceName: "slider-default7-handle.png")
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    func configureViews() {
        

        lowValue = minimumValue
        higherValue = maximumValue
        lowMaximumValue = Double.nan
        higherMinimumValue = Double.nan
        
        
        
        
        
        
        let backgroundRect = CGRect(x: 0, y: self.frame.size.height/2, width: self.frame.size.width, height: 5)
        trackBackgroundImageView = UIImageView(frame: backgroundRect)
        trackBackgroundImageView.backgroundColor = .blue
        addSubview(self.trackBackgroundImageView)
        
        lowHandle = UIImageView(image: defaultHandleImage)
        lowHandle.frame = CGRect(x: 40, y: 20, width: 20, height: 20)
        addSubview(lowHandle)
        
        higherHandle = UIImageView(image: defaultHandleImage)
        higherHandle.frame = CGRect(x: 200, y: 20, width: 20, height: 20)
        addSubview(higherHandle)
        
        
        
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        let lowRect = UIEdgeInsetsInsetRect(lowHandle.frame, lowTouchEdgeInsets)
        if lowRect.contains(touchPoint) {
            lowHandle.isHighlighted = true
            
        }
        
        let higherRect = UIEdgeInsetsInsetRect(higherHandle.frame, higherTouchEdgeInsets)
        if higherRect.contains(touchPoint) {
            higherHandle.isHighlighted = true
        }
    
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if lowHandle.isHighlighted == false && higherHandle.isHighlighted == false {
            return true
        }
        let touchPoint = touch.location(in: self)
        
        
        
        
        
        if lowHandle.isHighlighted {
            let newValue = lowValueForCenterX(x: Double(touchPoint.x))
            if newValue < lowValue || !higherHandle.isHighlighted {
                higherHandle.isHighlighted = false
                bringSubview(toFront: lowHandle)
                
                let pointX = touchPoint.x
                let pointY = lowHandle.center.y
                lowHandle.center = CGPoint(x: pointX, y: pointY)
                
            } else {
                lowHandle.isHighlighted = false
            }
            
        }
        
        if higherHandle.isHighlighted {
            
            let newValue = lowValueForCenterX(x: Double(touchPoint.x))
            
            if newValue > higherValue || !lowHandle.isHighlighted {
                
                lowHandle.isHighlighted = false
                bringSubview(toFront: higherHandle)
                
                let pointX = touchPoint.x
                let pointY = higherHandle.center.y
                higherHandle.center = CGPoint(x: pointX, y: pointY)
            } else {
                higherHandle.isHighlighted = false
            }
            
            
        }
        
        return true
    }
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowHandle.isHighlighted = false
        higherHandle.isHighlighted = false
    }
    
    
    
    func lowValueForCenterX(x:Double) -> Double {
        
        
        
        
        let padding = Double(lowHandle.frame.size.width/2.0)
        let valueGap = maximumValue - minimumValue
        let lengthMinusPadding = Double(self.frame.size.width) - padding * 2
        
        
        
        let value:Double = (x - padding) / lengthMinusPadding * valueGap
        
        return value
    }
    
//    func higherValueForCenterX(x:Double) -> Double {
//        let padding = Double(higherHandle.frame.size.width/2.0)
//        let valueGap = maximumValue - minimumValue
//        
//    }
    
    func setValue(low:Double, higher:Double, animated:Bool) {
        
        
        
        
        
    }
    
    func setlowValue(value:Double, animated:Bool) {
        setValue(low: lowValue, higher: Double.nan, animated: true)
    }
    
    func setHigherValue(value:Double, animated:Bool) {
        setValue(low: Double.nan, higher: value, animated: true)
    }
    
    func setlowValue(lowValue:Double) {
        var value = lowValue
        value = min(value, maximumValue)
        value = max(value, minimumValue)
        
        if !lowMaximumValue.isNaN {
            value = min(value, lowMaximumValue)
        }
        value = min(value, higherValue - minimumRange)
        self.lowValue = value
        
        setNeedsDisplay()
    }
    
    func setHigherValue(higherValue:Double) {
        var value = higherValue
        value = max(value, minimumValue)
        value = min(value, maximumValue)
        if !higherMinimumValue.isNaN {
            value = max(value, higherMinimumValue)
        }
        value = max(value, lowValue + minimumRange)
        self.higherValue = value
        setNeedsDisplay()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
