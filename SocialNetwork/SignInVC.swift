//
//  ViewController.swift
//  SocialNetwork
//
//  Created by COMPUTER on 7/24/17.
//  Copyright © 2017 COMPUTER. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
   FBSDKSettings.setAppID("SocialNetwork")


    
    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("ELI: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("ELI: User cancelled Facebook authentication")
            } else {
                print("ELI: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    
    
    
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("ELI: Unable to authenticate with Firebase - \(error)")
            } else {
                print("ELI: Succesfully authenticated with Firebase")
            }
        }
    }
    
    
    
    
    

}

