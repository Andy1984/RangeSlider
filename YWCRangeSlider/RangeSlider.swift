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
    
    /// defalut 0.0, could be negative. The minimum distance between the low value and high value
    var minimumDistance = 0.0
    
    /// default 0.0
    var stepValue = 0.0

    /// default false. If true, the slider ball will not move until it hit a new step.
    var stepByStep = false

    /// stepValueInternal = stepByStep ? stepValue : 0.0f;
    private var stepValueInternal = 0.0
    
    /// default true. If false, it will not trigger valueChanged until the touch ends.
    var changeValueContinously = true
    
    private var _lowValue = 0.0
    /// default 0.0
    var lowValue: Double {
        set {
            var value = newValue
            if stepValueInternal > 0 {
                value = round(value / stepValueInternal) * stepValueInternal
            }
        
            value = min(value, maximumValue)
            value = max(value, minimumValue)
            if !lowMaximumValue.isNaN {
                value = min(value, lowMaximumValue)
            }
            value = min(value, highValue - minimumDistance)
            _lowValue = value
            setNeedsLayout()
        }
        get {
            return _lowValue
        }
    }
    
    private var _highValue = 0.0
    /// default = maximumValue
    var highValue:Double{
        set {
            var value = newValue
            if stepValueInternal > 0 {
                value = round(value / stepValueInternal) * stepValueInternal
            }
            value = max(value, minimumValue)
            value = min(value, maximumValue)
            if !highMinimumValue.isNaN {
                value = max(value, highMinimumValue)
            }
            value = max(value, lowValue + minimumDistance)
            _highValue = value
            setNeedsLayout()
        }
        get {
            return _highValue
        }
    }
    
    ///  maximum value for left thumb, default nan
    var lowMaximumValue = Double.nan
    
    /// minimum value for right thumb, default nan
    var highMinimumValue = Double.nan
    
    /// default is 2.0
    var sliderLineHeight = 2.0;
    
    /// make left thumb easy to touch. Default UIEdgeInsetsMake(-5, -5, -5, -5)
    var lowTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5)
    /// make right thumb easy to touch. Default UIEdgeInsetsMake(-5, -5, -5, -5)
    let highTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5)
    
    var trackImageView: UIImageView!
    
    var trackImage: UIImage {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        v.backgroundColor = .blue
        return getImageFrom(view: v)
    }
    
    var trackCrossedImage: UIImage {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        v.backgroundColor = .red
        return getImageFrom(view: v)
    }
    
    
    /// Default is nil, and use the shadow ball of system
    var lowHandleImageNormal: UIImage?
    var highHandImageNormal: UIImage?
    var lowHandleImageHighlighted: UIImage?
    var highHandleImageHighlighted: UIImage?
    
    
    var trackBackgroundImageView: UIImageView!
    var lowHandle: UIImageView!
    var highHandle: UIImageView!
    
    var hideLowHandle = false
    var hideHighHandle = false
    
    private var lowTouchOffset = 0.0
    private var highTouchOffset = 0.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func trackImageForCurrentValues() -> UIImage {
        if lowValue <= highValue {
            return trackImage
        } else {
            return trackCrossedImage
        }
    }
    
    
    
    func configureViews() {
        
        
        lowValue = minimumValue
        highValue = maximumValue
        lowMaximumValue = Double.nan
        highMinimumValue = Double.nan
        
        
        
        trackBackgroundImageView = UIImageView(frame: trackBackgroundRect())
        trackBackgroundImageView.backgroundColor = .gray
        addSubview(self.trackBackgroundImageView)
        
        trackImageView = UIImageView()
        addSubview(trackImageView)
        
        
        lowHandle = UIImageView()
        addSubview(lowHandle)
        
        highHandle = UIImageView()
        addSubview(highHandle)
        
        
        
        
    }
    
    
    
    
    
    func lowValueForCenterX(x:Double) -> Double {
        let padding = Double(lowHandle.frame.size.width/2.0)
        let valueGap = maximumValue - minimumValue
        let lengthMinusPadding = Double(self.frame.size.width) - padding * 2
        var value:Double = minimumValue + (x - padding) / lengthMinusPadding * valueGap
        
        //Inhabit setValue programmatically over range
        value = max(value, minimumValue)
        value = min(value, highValue - minimumDistance)
        
        return value
    }
    
    func highValueForCenterX(x:Double) -> Double {
        let padding = Double(highHandle.frame.size.width/2.0)
        let valueGap = maximumValue - minimumValue
        let lengthMinusPadding = Double(self.frame.size.width) - padding * 2
        var value:Double = minimumValue + (x - padding) / lengthMinusPadding * valueGap
        
        //Inhabit setValue programmatically over range
        value = min(value, maximumValue)
        value = max(value, lowValue + minimumDistance)
        
        return value
    }
    
    func setValue(low:Double, high:Double, animated:Bool) {
        var duration = 0.0
        if animated {
            duration = 0.25
        }
        UIView.animate(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
            if !low.isNaN {
                self.lowValue = low
            }
            if !high.isNaN {
                self.highValue = high
            }
            
        }) { (finished) in
            self.setNeedsLayout()
        }
    }
    
    func setLowValue(value:Double, animated:Bool) {
        setValue(low: value, high: Double.nan, animated: animated)
    }
    
    func setHighValue(value:Double, animated:Bool) {
        setValue(low: Double.nan, high: value, animated: animated)
    }
    
    func trackRect() -> CGRect {
        let y = trackBackgroundRect().minY
        let x = min(lowHandle.frame.minX, highHandle.frame.minX)
        let h = trackBackgroundRect().height
        let rightX = max(lowHandle.frame.maxX, highHandle.frame.maxX)
        let w = rightX - x
        let rect = CGRect(x: x, y: y, width: w, height: h)
        return rect
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if hideLowHandle {
            lowValue = minimumValue
        }
        if hideHighHandle {
            highValue = maximumValue
        }
        
        lowHandle.image = lowHandleImageNormal
        lowHandle.highlightedImage = lowHandleImageHighlighted
        highHandle.image = highHandImageNormal
        highHandle.highlightedImage = highHandleImageHighlighted
        
        if lowHandle.image == nil {
            lowHandle.frame = handleRectFor(value: lowValue, size: CGSize(width: 31, height: 31))
            becomeSystemBall(ball: lowHandle)
        } else {
            lowHandle.frame = handleRectFor(value: lowValue, size: lowHandle.image!.size)
            backToImage(ball: lowHandle)
        }
        
        if highHandle.image == nil {
            highHandle.frame = handleRectFor(value: highValue, size: CGSize(width: 31, height: 31))
            becomeSystemBall(ball: highHandle)
        } else {
            highHandle.frame = handleRectFor(value: highValue, size: highHandle.image!.size)
            backToImage(ball: highHandle)
        }
        
        trackImageView.image = trackImageForCurrentValues()
        trackImageView.frame = trackRect()
        
    }
    
    func trackBackgroundRect() -> CGRect {
        let x = 0.0
        let y = (Double(frame.size.height) - sliderLineHeight)/2
        let width = Double(self.frame.size.width)
        let height = sliderLineHeight
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func handleRectFor(value:Double, size: CGSize) -> CGRect {
        var handleRect = CGRect(origin: CGPoint.zero, size: size)
        
        
        
        let xValue = Double(self.bounds.size.width - handleRect.size.width) * (value - minimumValue) / (maximumValue - minimumValue)
        let originY = Double(self.bounds.size.height)/2.0 - Double(handleRect.size.height)/2
        
        
        let originPoint = CGPoint(x: xValue, y:originY)
        handleRect.origin = originPoint
        return handleRect.integral
    }
    
    
    private func becomeSystemBall(ball:UIImageView) {
        ball.layer.cornerRadius = 31/2;
        ball.layer.shadowOffset = CGSize(width:0, height:2);
        ball.layer.shadowOpacity = 0.5;
        ball.backgroundColor = .white
        ball.layer.shadowColor = UIColor.black.cgColor
    }
    
    private func backToImage(ball:UIImageView) {
        ball.layer.cornerRadius = 0;
        ball.layer.shadowOffset = CGSize.zero;
        ball.layer.shadowOpacity = 0;
        ball.backgroundColor = .clear
        ball.layer.shadowColor = UIColor.clear.cgColor
    }
    
    /// Convert view to image
    ///
    /// - Parameter view:
    /// - Returns:
    private func getImageFrom(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot!
    }
    
    // MARK: - override UIControl method
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
        
        stepValueInternal = stepByStep ? stepValue : 0.0;
        
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
                setLowValue(value: low, animated: stepByStep)
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
                setHighValue(value: high, animated: stepByStep)
                
            } else {
                highHandle.isHighlighted = false
            }
        }
        
        if changeValueContinously {
            sendActions(for: .valueChanged)
        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowHandle.isHighlighted = false
        highHandle.isHighlighted = false
        if stepValue > 0 {
            stepValueInternal = stepValue
            setLowValue(value: lowValue, animated: true)
            setHighValue(value: highValue, animated: true)
        }
        sendActions(for: .valueChanged)
    }
    
    
    
}
