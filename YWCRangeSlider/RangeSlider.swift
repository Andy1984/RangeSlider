//
//  RangeSlider.swift
//  YWCRangeSlider
//
//  Created by YangWeicheng on 15/05/2017.
//  Copyright © 2017 YWC. All rights reserved.
//

import UIKit

class RangeSlider: UIControl {
    
    var minValue = 0.0;
    var maxValue = 1.0;
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
        let backgroundRect = CGRect(x: 0, y: self.frame.size.height/2, width: self.frame.size.width, height: 5)
        trackBackgroundImageView = UIImageView(frame: backgroundRect)
        trackBackgroundImageView.backgroundColor = .white
        addSubview(self.trackBackgroundImageView)
        
        
//        trackImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20));
//        addSubview(trackImageView)
//        trackImageView.backgroundColor = .red
        
        lowerHandle = UIImageView(image: defaultHandleImage)
        lowerHandle.frame = CGRect(x: 40, y: 20, width: 20, height: 20);
        addSubview(lowerHandle)
        
        
        
        
        
        
    }
    
    
    
    
    
    
    

}
