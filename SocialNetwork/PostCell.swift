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

    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        
    let url = URL(string: post.imageUrl)
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: url!)
                DispatchQueue.global().sync {
                    self.postImg.image = UIImage(data: data)
               
                }
                
            }catch{
                //handle error
            }

    }
    
    
    
}

}
