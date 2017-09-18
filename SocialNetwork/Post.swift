//
//  Post.swift
//  SocialNetwork
//
//  Created by COMPUTER on 8/22/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import Foundation
import Firebase
import Firebase
class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: DatabaseReference
    
var caption: String {
    return _caption
}

var imageUrl: String {
    return _imageUrl
}

var likes: Int {
    return _likes
}

var postKey: String {
    return _postKey
}

var postRef: DatabaseReference {
        return _postRef
    }

    init(caption: String, imageUrl: String, likes: Int, postRef: DatabaseReference) {
    self._caption = caption
    self._imageUrl = imageUrl
    self._likes = likes
    self._postRef = postRef
    }

    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        //USED FOR: Converting Data from Firebase into something we can use in our code
        self._postKey = postKey
        
        //now, SINCE WE DON'T KNOW if there will be anyting in the postData, we need to make ALL THE STUFF BELOW an IF LET for each one
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int? {
            self._likes = likes
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    func adjustLikes(addLike: Bool){
        if addLike == true {
            self._likes = _likes + 1
            
        } else {
            self._likes = _likes - 1
        }
    postRef.child("likes").setValue(_likes)
    }
}
