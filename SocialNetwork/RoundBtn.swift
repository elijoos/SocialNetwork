//
//  RoundBtn.swift
//  SocialNetwork
//
//  Created by COMPUTER on 7/26/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit

class RoundBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
 
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.8).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
        //sometimes the scale setting in attribute inspector doensn't work so this is just to make sure
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
    }
}
