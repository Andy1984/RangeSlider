//
//  RangeSlider.swift
//  YWCRangeSlider
//
//  Created by YangWeicheng on 15/05/2017.
//  Copyright © 2017 YWC. All rights reserved.
//

import UIKit

@IBDesignable
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
    var stepValueContinuously = false

    /// stepValueInternal = stepValueContinuously ? stepValue : 0.0f;
    private var stepValueInternal = 0.0

    /// default true. If false, it will not trigger valueChanged until the touch ends.
    var changeValueContinuously = true

    /// default false, if true, it become a single thumb slider
    var isHighHandleHidden = false {
        didSet {
            setNeedsLayout()
        }
    }

    /// default false, isHighHandleHidden counterpart, should be useless
    var isLowHandleHidden = false {
        didSet {
            setNeedsLayout()
        }
    }

    /// low center point
    private(set) var lowCenter: CGPoint = .zero

    /// high center point
    private(set) var highCenter: CGPoint = .zero

    /// default doing nothing, will call this block when lowCenter and highCenter changed
    var centersChangedHandler:() -> Void = {}

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            guard let handle = object as? UIImageView else {
                return
            }
            if handle == lowHandle {
                lowCenter = lowHandle.center
                centersChangedHandler()
            } else if handle == highHandle {
                highCenter = highHandle.center
                centersChangedHandler()
            }
        }
    }

    deinit {
        lowHandle.removeObserver(self, forKeyPath: "frame")
        highHandle.removeObserver(self, forKeyPath: "frame")
    }

    /// setLowValue would call layoutSubviews, must not call setLowValue in the layoutSubviews
    private var _lowValue = 0.0
    /// default 0.0, set method does not send action
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

    /// setHighValue would call layoutSubviews, must not call setHighValue in the layoutSubviews
    private var _highValue = 0.0
    /// default = maximumValue, does not send action
    var highValue: Double {
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

    /// move slider animatedly. does not send action
    ///
    /// - Parameters:
    ///   - low:
    ///   - high:
    ///   - animated:
    func setValue(low: Double, high: Double, animated: Bool) {
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
            self.layoutIfNeeded() // must include this line in the animation block
        }) { _ in
        }
    }

    ///  maximum value for left thumb, default nan
    var lowMaximumValue = Double.nan

    /// minimum value for right thumb, default nan
    var highMinimumValue = Double.nan

    /// default is 2.0, it works if trackBackgroundImage is nil
    var sliderLineHeight = 2.0

    /// make left thumb easy to touch. Default UIEdgeInsetsMake(-5, -5, -5, -5)
    var lowTouchEdgeInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
    /// make right thumb easy to touch. Default UIEdgeInsetsMake(-5, -5, -5, -5)
    let highTouchEdgeInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)

    /// the imageView of value bar
    private var trackImageView: UIImageView!

    /// the length of default ball
    private let systemBallLength: CGFloat = 28.0

    /// the image of value bar
    var trackImage = RangeSlider.getImage1x2(color: #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1))

    /// the image of value bar when crossed
    var trackCrossedImage = RangeSlider.getImage1x2(color: .red)

    /// Default is nil, and use the shadow ball of system
    var lowHandleImageNormal: UIImage? {
        didSet {
            if lowHandleImageNormal == nil {
                becomeSystemBall(ball: lowHandle)
            } else {
                backToImage(ball: lowHandle)
            }
        }
    }

    /// Default is nil, and use the shadow ball of system
    var highHandleImageNormal: UIImage? {
        didSet {
            if highHandleImageNormal == nil {
                becomeSystemBall(ball: highHandle)
            } else {
                backToImage(ball: highHandle)
            }
        }
    }

    var lowHandleImageHighlighted: UIImage?
    var highHandleImageHighlighted: UIImage?

    /// backgroundImage of the bar, default is a gray 1x2 image
    var trackBackgroundImage: UIImage! {
        didSet {
            self.trackBackgroundImageView.image = trackBackgroundImage
            self.trackBackgroundImageView.frame = trackBackgroundRect()
            setNeedsLayout()
        }
    }
    private var trackBackgroundImageView: UIImageView!

    /// Keep it private, given that it is useless to change its image directly
    private var lowHandle: UIImageView!
    /// Keep it private, given that it is useless to change its image directly
    private var highHandle: UIImageView!

    private var lowTouchOffset = 0.0
    private var highTouchOffset = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }

    func trackImageForCurrentValues() -> UIImage {
        if lowValue <= highValue {
            return trackImage
        } else {
            return trackCrossedImage
        }
    }

    private func configureViews() {

        _lowValue = minimumValue
        _highValue = maximumValue
        lowMaximumValue = Double.nan
        highMinimumValue = Double.nan

        trackBackgroundImageView = UIImageView()
        //trackBackgroundImage didSet will set frame
        trackBackgroundImage = RangeSlider.getImage1x2(color: #colorLiteral(red: 0.7333333333, green: 0.7333333333, blue: 0.7333333333, alpha: 1))
        addSubview(self.trackBackgroundImageView)

        trackImageView = UIImageView()
        addSubview(trackImageView)

        lowHandle = UIImageView()
        addSubview(lowHandle)
        highHandle = UIImageView()
        addSubview(highHandle)
        lowHandle.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        highHandle.addObserver(self, forKeyPath: "frame", options: .new, context: nil)

        becomeSystemBall(ball: lowHandle)
        becomeSystemBall(ball: highHandle)
    }

    func lowValueForCenterX(x: Double) -> Double {
        let padding = Double(lowHandle.frame.size.width / 2.0)
        let valueGap = maximumValue - minimumValue
        let lengthMinusPadding = Double(self.frame.size.width) - padding * 2
        var value: Double = minimumValue + (x - padding) / lengthMinusPadding * valueGap

        // Inhabit setValue programmatically over range
        value = max(value, minimumValue)
        value = min(value, highValue - minimumDistance)

        return value
    }

    func highValueForCenterX(x: Double) -> Double {
        let padding = Double(highHandle.frame.size.width / 2.0)
        let valueGap = maximumValue - minimumValue
        let lengthMinusPadding = Double(self.frame.size.width) - padding * 2
        var value: Double = minimumValue + (x - padding) / lengthMinusPadding * valueGap

        // Inhabit setValue programmatically over range
        value = min(value, maximumValue)
        value = max(value, lowValue + minimumDistance)

        return value
    }

    func trackRect() -> CGRect {
        let lowHandleWidth = lowHandle.image?.size.width ?? systemBallLength
        let highHandleWidth = highHandle.image?.size.width ?? systemBallLength
        let y = trackBackgroundRect().minY
        var x = min(lowHandle.frame.minX, highHandle.frame.minX) + lowHandleWidth / 2
        let h = trackBackgroundRect().height
        var rightX = max(lowHandle.frame.maxX, highHandle.frame.maxX) - highHandleWidth / 2
        var w = rightX - x
        if isLowHandleHidden == true {
            x = 0
            w = rightX
        }
        if isHighHandleHidden == true {
            rightX = max(lowHandle.frame.maxX, highHandle.frame.maxX)
            w = rightX - x
        }
        let rect = CGRect(x: x, y: y, width: w, height: h)
        return rect
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if isLowHandleHidden {
            _lowValue = minimumValue
        }
        if isHighHandleHidden {
            _highValue = maximumValue
        }

        // lowHandle
        lowHandle.image = lowHandleImageNormal
        lowHandle.highlightedImage = lowHandleImageHighlighted
        lowHandle.isHidden = isLowHandleHidden
        if lowHandle.image == nil {
            lowHandle.frame = handleRectFor(value: lowValue, size: CGSize(width: systemBallLength, height: systemBallLength))
        } else {
            lowHandle.frame = handleRectFor(value: lowValue, size: lowHandle.image!.size)
        }

        // highHandle
        highHandle.image = highHandleImageNormal
        highHandle.highlightedImage = highHandleImageHighlighted
        highHandle.isHidden = isHighHandleHidden
        if highHandle.image == nil {
            highHandle.frame = handleRectFor(value: highValue, size: CGSize(width: systemBallLength, height: systemBallLength))
        } else {
            highHandle.frame = handleRectFor(value: highValue, size: highHandle.image!.size)
        }

        trackImageView.image = trackImageForCurrentValues()
        trackImageView.frame = trackRect()

    }

    func trackBackgroundRect() -> CGRect {
        let x: Double = 0.0
        let y: Double = Double(self.frame.size.height - trackBackgroundImage.size.height) / 2
        let width: Double = Double(self.frame.size.width)
        let height: Double = Double(trackBackgroundImage.size.height)
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func handleRectFor(value: Double, size: CGSize) -> CGRect {
        var handleRect = CGRect(origin: CGPoint.zero, size: size)

        let xValue = Double(self.bounds.size.width - handleRect.size.width) * (value - minimumValue) / (maximumValue - minimumValue)
        let originY = Double(self.bounds.size.height) / 2.0 - Double(handleRect.size.height) / 2

        let originPoint = CGPoint(x: xValue, y: originY)
        handleRect.origin = originPoint
        return handleRect.integral
    }

    private func becomeSystemBall(ball: UIImageView) {
        ball.layer.cornerRadius = systemBallLength / 2
        ball.layer.shadowOffset = CGSize(width: 0, height: 2)
        ball.layer.shadowOpacity = 0.5
        ball.backgroundColor = .white
        ball.layer.shadowColor = UIColor.black.cgColor
    }

    private func backToImage(ball: UIImageView) {
        ball.layer.cornerRadius = 0
        ball.layer.shadowOffset = CGSize.zero
        ball.layer.shadowOpacity = 0
        ball.backgroundColor = .clear
        ball.layer.shadowColor = UIColor.clear.cgColor
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

        stepValueInternal = stepValueContinuously ? stepValue : 0.0

        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if lowHandle.isHighlighted == false && highHandle.isHighlighted == false {
            return true
        }
        let touchPoint = touch.location(in: self)

        if lowHandle.isHighlighted {

            let newValue = lowValueForCenterX(x: Double(touchPoint.x) - lowTouchOffset)

            if newValue < lowValue || !highHandle.isHighlighted {
                highHandle.isHighlighted = false
                bringSubview(toFront: lowHandle)

                let pointX = Double(touchPoint.x)
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

                let pointX = Double(touchPoint.x.native)
                let high = highValueForCenterX(x: pointX)
                setValue(lgit ow: Double.nan, high: high, animated: stepValueContinuously)

            } else {
                highHandle.isHighlighted = false
            }
        }

        if changeValueContinuously {
            sendActions(for: .valueChanged)
        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowHandle.isHighlighted = false
        highHandle.isHighlighted = false
        if stepValue > 0 {
            stepValueInternal = stepValue
            setValue(low: lowValue, high: highValue, animated: true)
        }
        sendActions(for: .valueChanged)
    }

    // MARK: - class method to create image fast

    /// convert view to image
    class func getImage(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenShot!
    }

    /// create a image with color
    class func getImage(color: UIColor, rect: CGRect) -> UIImage {
        let v = UIView(frame: rect)
        v.backgroundColor = color
        return getImage(view: v)
    }

    class func getImage1x2(color: UIColor) -> UIImage {
        return getImage(color: color, rect: CGRect(x: 0, y: 0, width: 1, height: 2))
    }
}
