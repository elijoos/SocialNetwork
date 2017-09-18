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

    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    
    var likesRef: DatabaseReference!
    //Here we arent referencing a specific point but we will in ~line 45 where we set the value for this in the configure cell because otherwise it will do it for ALL THE CELLS
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
       
    likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        //in our data service under our current user there is a child called likes; we aren't creating it, just a reference (we hardcoded it earlier)
        
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
   // let likesRef = DataService.ds.REF_USER_CURRENT.child("likes")
        //in our data service under our current user there is a child called likes; we aren't creating it, just a reference (we hardcoded it earlier)
        //moved it to top of class because using it more than once ^^^
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
            
            //When this cell is configured its going to check if it has been liked by the current user
        })
    
    
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                //WE SWITCHED EMPTY TO FILLED ON THIS PART^
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                //WE SWITCHED FILLED TO EMPTY ON THIS PART^
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
            //think about it. In the configureCell we call this to change depending on if the user liked the pic or not. THIS PART is when the user TAPS ON IT, then the snapshot is not = to nil and therefore it will make it empty of filled already, or filled if empty already
            
        })

    }
    
    
}
















