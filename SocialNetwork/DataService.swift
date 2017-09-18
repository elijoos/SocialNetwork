//
//  DataService.swift
//  SocialNetwork
//
//  Created by COMPUTER on 8/15/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
//this is the reference to the URL OF OUR DATABASE. (we don't specify url because this databaseUrl is in our GoogleService-Info.plist...go look)

let STORAGE_BASE = Storage.storage().reference()


class DataService {
    
    static let ds = DataService()
    
    
    //DB References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    //the reference to the "posts" in our firebase database.
    //Think of this like it's adding "posts" to the end of the databse url
    private var _REF_USERS = DB_BASE.child("users")
    
    
    //Storage References
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
        //getting our uid from our KeychainWrapper, makeing reference to users in database, then passing in our uid as a child in our users part of our datbase
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        //if a new user, firebase will create it, otherwise it will just add onto the existing user
    }
    
}
