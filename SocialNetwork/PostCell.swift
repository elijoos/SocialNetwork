//
//  PostCell.swift
//  SocialNetwork
//
//  Created by COMPUTER on 8/7/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit
import Firebase

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
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil  {
            self.postImg.image = img
        } else {
            //if image isn't downloaded, here's where we do in cache
            
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                
                if error != nil {
                    print("ELI: Unable to download image from Firebase storage \(String(describing: error))")
                } else {
                   print("ELI: Image downloaded from Firebase storage")
                    
                    if let imgData = data {
                        if let image = UIImage(data: imgData) {
                           
                            self.postImg.image = image
                            
                            
                            FeedVC.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                            
                            //the forKey is post.imageUrl because it is the location in the cache
                        }
                    }
                    
                    
                }
            })
        }
        
    }
    
    
    
}
















