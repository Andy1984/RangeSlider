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
    
    /// defalut 0.0 The minimum distance between the low value and high value
    var minimumRange = 0.0
    
    var stepValueContinuously = false
    
    var lowValue = 0.0
    var highValue = 0.0
    
    ///  maximum value for left thumb
    var lowMaximumValue = 0.0
    
    /// minimum value for right thumb
    var highMinimumValue = 0.0
    
    /// default is 2.0
    var sliderLineHeight = 2.0;
    
    var lowTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5)
    let highTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5)
    
    var trackImageView: UIImageView!
    var trackBackgroundImageView: UIImageView!
    var lowHandle: UIImageView!
    var highHandle: UIImageView!
    
    
    
    private var lowCenter: CGPoint!
    private var highCenter: CGPoint!
    
    var hideLowHandle = false
    var hideHighHandle = false
    
    private var lowTouchOffset = 0.0
    private var highTouchOffset = 0.0
    
    
    
    
    var defaultHandleImage = #imageLiteral(resourceName: "slider-default7-handle.png")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    func configureViews() {
        

        lowValue = minimumValue
        highValue = maximumValue
        lowMaximumValue = Double.nan
        highMinimumValue = Double.nan
        
        
        trackBackgroundImageView = UIImageView(frame: trackBackgroundRect())
        trackBackgroundImageView.backgroundColor = .blue
        addSubview(self.trackBackgroundImageView)
        
        lowHandle = UIImageView(image: defaultHandleImage)
        lowHandle.frame = handleRectFor(value: 0, image: lowHandle.image!)
        addSubview(lowHandle)
        
        highHandle = UIImageView(image: defaultHandleImage)
        highHandle.frame = handleRectFor(value: 1.0, image: highHandle.image!)
        addSubview(highHandle)
        
        
        
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        let lowRect = UIEdgeInsetsInsetRect(lowHandle.frame, lowTouchEdgeInsets)
        if lowRect.contains(touchPoint) {
            lowHandle.isHighlighted = true
            lowTouchOffset = Double(touchPoint.x - lowHandle.center.x)
        }
        
        let highRect = UIEdgeInsetsInsetRect(highHandle.frame, highTouchEdgeInsets)
        if highRect.contains(touchPoint) {
            highHandle.isHighlighted = true
            highTouchOffset = Double(touchPoint.x - highHandle.center.x)
        }
    
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if lowHandle.isHighlighted == false && highHandle.isHighlighted == false {
            return true
        }
        let touchPoint = touch.location(in: self)
        
        
        
        
        
        if lowHandle.isHighlighted {
            
            let newValue = lowValueForCenterX(x: touchPoint.x.native - lowTouchOffset)
            
            if newValue < lowValue || !highHandle.isHighlighted {
                highHandle.isHighlighted = false
                bringSubview(toFront: lowHandle)
                
                let pointX = touchPoint.x.native
                let low = lowValueForCenterX(x: pointX)
                
                setValue(low: low, high: Double.nan, animated: stepValueContinuously)
                
            } else {
                lowHandle.isHighlighted = false
            }
            
        }
        
        if highHandle.isHighlighted {
            
            let newValue = lowValueForCenterX(x: Double(touchPoint.x))
            
            if newValue > highValue || !lowHandle.isHighlighted {
                
                lowHandle.isHighlighted = false
                bringSubview(toFront: highHandle)
                
                let pointX = touchPoint.x.native
                let high = highValueForCenterX(x: pointX)
                setValue(low: Double.nan, high: high, animated: stepValueContinuously)
            } else {
                highHandle.isHighlighted = false
            }
            
            
        }
        
        return true
    }
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowHandle.isHighlighted = false
        highHandle.isHighlighted = false
    }
    
    
    
    func lowValueForCenterX(x:Double) -> Double {
        let padding = Double(lowHandle.frame.size.width/2.0)
        let valueGap = maximumValue - minimumValue
        let lengthMinusPadding = Double(self.frame.size.width) - padding * 2
        var value:Double = minimumValue + (x - padding) / lengthMinusPadding * valueGap
        
        //Inhabit setValue programmatically over range
        value = max(value, minimumValue)
        value = min(value, highValue - minimumRange)
        
        return value
    }
    
    func highValueForCenterX(x:Double) -> Double {
        let padding = Double(highHandle.frame.size.width/2.0)
        let valueGap = maximumValue - minimumValue
        let lengthMinusPadding = Double(self.frame.size.width) - padding * 2
        var value:Double = minimumValue + (x - padding) / lengthMinusPadding * valueGap
        
        //Inhabit setValue programmatically over range
        value = min(value, maximumValue)
        value = max(value, lowValue + minimumRange)
        
        return value
    }
    
    func setValue(low:Double, high:Double, animated:Bool) {
        
        
        
        var duration = 0.0
        if animated {
            duration = 0.25
        }
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
            if !low.isNaN {
                self.setlowValue(lowValue: low)
            }
            if !high.isNaN {
                self.sethighValue(highValue: high)
            }
            
        }) { (finished) in
            self.setNeedsLayout()
        }
    }
    
    func setLowValue(value:Double, animated:Bool) {
        setValue(low: lowValue, high: Double.nan, animated: true)
    }
    
    func setHighValue(value:Double, animated:Bool) {
        setValue(low: Double.nan, high: value, animated: true)
    }
    
    func setlowValue(lowValue:Double) {
        var value = lowValue
        value = min(value, maximumValue)
        value = max(value, minimumValue)
        
        if !lowMaximumValue.isNaN {
            value = min(value, lowMaximumValue)
        }
        value = min(value, highValue - minimumRange)
        self.lowValue = value
        
        setNeedsLayout()
    }
    
    func sethighValue(highValue:Double) {
        var value = highValue
        value = max(value, minimumValue)
        value = min(value, maximumValue)
        if !highMinimumValue.isNaN {
            value = max(value, highMinimumValue)
        }
        value = max(value, lowValue + minimumRange)
        self.highValue = value
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if hideLowHandle {
            lowValue = minimumValue
        }
        if hideHighHandle {
            highValue = maximumValue
        }
        lowHandle.frame = handleRectFor(value: lowValue, image: lowHandle.image!)
        highHandle.frame = handleRectFor(value: highValue, image: highHandle.image!)
        
        
//        self.lowHandle.frame = 
    }
    
    func trackBackgroundRect() -> CGRect {
        let x = 0.0
        let y = (Double(frame.size.height) - sliderLineHeight)/2
        let width = Double(self.frame.size.width)
        let height = sliderLineHeight
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
//    func trackRect() -> CGRect {
//    
//    }
    
    func handleRectFor(value:Double, image: UIImage) -> CGRect {
        var handleRect = CGRect(origin: CGPoint.zero, size: image.size)
        
        let insets = image.capInsets
        if insets.top != 0 || insets.bottom != 0 {
            handleRect.size.height = self.bounds.size.height
        }
        
        let xValue = Double(self.bounds.size.width - handleRect.size.width) * (value - minimumValue) / (maximumValue - minimumValue)
        let originY = Double(self.bounds.size.height)/2.0 - Double(handleRect.size.height)/2
        
        
        let originPoint = CGPoint(x: xValue, y:originY)
        handleRect.origin = originPoint
        return handleRect.integral
    }

}
