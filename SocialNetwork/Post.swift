//
//  Post.swift
//  SocialNetwork
//
//  Created by COMPUTER on 8/22/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!

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


init(caption: String, imageUrl: String, likes: Int) {
    self._caption = caption
    self._imageUrl = imageUrl
    self._likes = likes
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
        
    }
    
}
