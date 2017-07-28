//
//  FancyField.swift
//  SocialNetwork
//
//  Created by COMPUTER on 7/27/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
        //creating an inset for the PLACEHOLDER text in text fields BECAUSE when we click the button to remove the borders in the attributes inspector apple is dumb how they put the placeholder text too far left
    }
    
    
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //SAME SITUATION AS ABOVE EXCEPT THIS IS FOR THE TEXT ITSELF NOT PLACEHOLDER
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    
    
    
}
