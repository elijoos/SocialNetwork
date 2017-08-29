//
//  CircleView.swift
//  SocialNetwork
//
//  Created by COMPUTER on 8/6/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.8).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = self.frame.width / 2
    }
}
