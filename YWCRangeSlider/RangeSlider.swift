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
    
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        configureViews();
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configureViews() {
        let rect = CGRect(x: 0, y: self.frame.size.height/2, width: self.frame.size.width, height: 5)
        trackBackgroundImageView = UIImageView(frame: rect)
        trackBackgroundImageView.backgroundColor = .white
        addSubview(self.trackBackgroundImageView)
        
    }
    
    func trackBackgroundRect() {
        
        
    }
    
    
    

}
