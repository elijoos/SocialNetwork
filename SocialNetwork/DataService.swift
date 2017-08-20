//
//  DataService.swift
//  SocialNetwork
//
//  Created by COMPUTER on 8/15/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
//this is the reference to the URL OF OUR DATABASE. (we don't specify url because this databaseUrl is in our GoogleService-Info.plist...go look)

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    //the reference to the "posts" in our firebase database.
    //Think of this like it's adding "posts" to the end of the databse url
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        //if a new user, firebase will create it
    }
    
}
