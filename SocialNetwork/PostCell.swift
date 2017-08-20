//
//  PostCell.swift
//  SocialNetwork
//
//  Created by COMPUTER on 8/7/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
