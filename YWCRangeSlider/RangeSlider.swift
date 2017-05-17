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
    
    /// defalut 0.0 The minimum distance between the lower value and higher value
    var minimumRange = 0.0
    
    var stepValueContinuously = false
    
    var lowerValue = 0.0
    var higherValue = 0.0
    
    var lowerTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5)
    let higherTouchEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5)
    
    var trackImageView: UIImageView!;
    var trackBackgroundImageView: UIImageView!;
    var lowerHandle: UIImageView!;
    var higherHandle: UIImageView!;
    private var lowCenter: CGPoint!;
    private var higherCenter: CGPoint!;
    
    
    
    var defaultHandleImage: UIImage = #imageLiteral(resourceName: "slider-default7-handle.png");
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        configureViews();
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    func configureViews() {
        
        
        lowerValue = minimumValue
        higherValue = maximumValue
        
        
        
        
        let backgroundRect = CGRect(x: 0, y: self.frame.size.height/2, width: self.frame.size.width, height: 5)
        trackBackgroundImageView = UIImageView(frame: backgroundRect)
        trackBackgroundImageView.backgroundColor = .blue
        addSubview(self.trackBackgroundImageView)
        
        lowerHandle = UIImageView(image: defaultHandleImage)
        lowerHandle.frame = CGRect(x: 40, y: 20, width: 20, height: 20);
        addSubview(lowerHandle)
        
        higherHandle = UIImageView(image: defaultHandleImage)
        higherHandle.frame = CGRect(x: 200, y: 20, width: 20, height: 20);
        addSubview(higherHandle)
        
        
        
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        let lowerRect = UIEdgeInsetsInsetRect(lowerHandle.frame, lowerTouchEdgeInsets)
        if lowerRect.contains(touchPoint) {
            lowerHandle.isHighlighted = true
            
        } else {
            lowerHandle.isHighlighted = false
        }
        let higherRect = UIEdgeInsetsInsetRect(higherHandle.frame, higherTouchEdgeInsets)
        if higherRect.contains(touchPoint) {
            higherHandle.isHighlighted = true
        } else {
            higherHandle.isHighlighted = false
        }
    
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if lowerHandle.isHighlighted == false && higherHandle.isHighlighted == false {
            return true
        }
        let touchPoint = touch.location(in: self)
        if lowerHandle.isHighlighted {
            let pointX = touchPoint.x
            let pointY = lowerHandle.center.y
            lowerHandle.center = CGPoint(x: pointX, y: pointY)
        }
        
        if higherHandle.isHighlighted {
            let pointX = touchPoint.x
            let pointY = higherHandle.center.y
            higherHandle.center = CGPoint(x: pointX, y: pointY)
        }
        
        return true;
    }
    
    
    
    
    func lowerValueForCenterX(x:Double) -> Double {
        let padding = Double(lowerHandle.frame.size.width/2.0)
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
    
    
    
    
    
    
    
    
    
    
    
    

}
