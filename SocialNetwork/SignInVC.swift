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

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
   
    @IBOutlet weak var errorField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
   FBSDKSettings.setAppID("SocialNetwork")


    
    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("ELI: Unable to authenticate with Facebook - \(String(describing: error))")
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
                print("ELI: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("ELI: Succesfully authenticated with Firebase")
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
    
        if let email = emailField.text, let pwd = pwdField.text {
            //IN OWN APPS PUT NOTIFICATION TO USER
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    print("ELI: User email authenticated with firebase")
                } else {
                    //this is error handling if user doesn't exist, or incorrect info. 
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        
                        if error != nil {
                            //this is if an error
                            if pwd.characters.count < 6 {
                                self.errorField.isHidden = false
                                
                            } else {
                              
                                
                                self.errorField.isHidden = false
                                self.errorField.text = "An error occured in your email"
                            }
                            
                            
                            
                            print("ELI: Unable to authenticate with Firebase using email")
                            
                        } else {
                            print("ELI: Succesfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
    }
    
    
    
    

}

