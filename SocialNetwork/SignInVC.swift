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
import SwiftKeychainWrapper


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
   
    @IBOutlet weak var errorField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
   FBSDKSettings.setAppID("SocialNetwork")

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //this segue isn't necessary right here; it is in that function at bottom but I might as well keep it here because I might need it for the facebook login
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            //above ^^ checking if key exists
           performSegue(withIdentifier: "goToFeed", sender: nil)
            print("ELI: ID found in keychain")
        }
         


    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("ELI: Unable to authenticate with Facebook - \(String(describing: error))")
            
            
            
            } else if result?.isCancelled == true {
                print("ELI: User cancelled Facebook authentication")
            }
            
            
            else {
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
                
                if let user = user{
                    self.completeSignIn(id: user.uid)
                }
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
    
        if let email = emailField.text, let pwd = pwdField.text {
            //IN OWN APPS PUT NOTIFICATION TO USER
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    print("ELI: User email authenticated with firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                
                
                
                } else {
                    //this is error handling if user doesn't exist, or incorrect info. 
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        
                        
                        
                        if error != nil {
                            //this is if an error
                            if pwd.characters.count < 6 && self.emailField.text != nil{
                                
                                self.errorField.text = "Password requires 6 or more characters"
                            }
                            if self.emailField.text == nil && self.pwdField.text == tnil {
                               

                                self.errorField.text = "Enter username and password to login"
                            }
                            
                            else {
                              
                             
                        self.errorField.text = "An error occured in your email"
                                
                            }
                            
                            
                            
                            print("ELI: Unable to authenticate with Firebase using email")
                            
                        } else {
                            print("ELI: Succesfully authenticated with Firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                           
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
      let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("ELI: Data saved to keychain \(keychainResult)")
        //user.uid is just the id of user
        //KEY_UID is just so we avoid a typo when we use this string more
   performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
    
    

}

